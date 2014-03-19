require 'securerandom'

class AudioEncoding < ActiveRecord::Base
  class EncodingJob
    @queue = "audiobox"

    class << self
      def perform(id)
        ae = AudioEncoding.find(id)
        ae.encode
      end
    end
  end

  TYPES = {
    'mp3' => 'MP3AudioEncoding',
    'aac' => 'AACAudioEncoding'
  }


  self.table_name = "preroller_audio_encodings"

  belongs_to :campaign,
    :class_name => "PrerollCampaign"

  before_destroy :delete_file
  after_create :encode_async


  attr_accessible \
    :stream_key,
    :campaign_id,
    :type


  def codec
    key_parts[0]
  end

  def extension
    # These may not always be the same.
    # For example, we may want an AAC encoding which returns an mp4 file
    # or something. In that cas we can just have a simple hash map defined
    # somewhere.
    self.codec
  end

  def sample_rate
    key_parts[1].to_i
  end

  def profile
    nil
  end

  def bitrate
    nil
  end

  def channels
    nil
  end


  def path
    return nil if !self.fingerprint || !self.campaign_id

    File.join(
      Rails.application.config.preroller.audio_dir,
      "#{self.campaign_id}-#{self.fingerprint}.#{self.extension}"
    )
  end


  def encode
    master = self.campaign.master_file

    # we'll encode into a temp file and then move it into place
    f = Tempfile.new(['preroller', ".#{self.extension}"])

    begin
      mfile = FFMPEG::Movie.new(master.path)
      mfile.transcode(f.path, transcode_options.merge({
        :custom => %Q! -metadata title="#{self.campaign.title.gsub('"','\"')}"!,
        :audio_sample_rate => self.sample_rate,
        :audio_channels    => self.channels
      }))

      # make sure the file we created is valid...
      newfile = FFMPEG::Movie.new(f.path)
      if newfile.valid?
        self.fingerprint = SecureRandom.hex(4)

        # now write it into place in our final location
        File.open(self.path, 'w', encoding: "ascii-8bit") do |ff|
          ff << f.read
        end

        self.save!
      end
    ensure
      f.close
      f.unlink
    end

    return true
  end


  private

  def key_parts
    @key_parts ||= self.stream_key.split("-")
  end

  def encode_async
    Resque.enqueue(EncodingJob, self.id)
  end

  def delete_file
    if self.path && File.exists?(self.path)
      File.delete(self.path)
    end
  end
end
