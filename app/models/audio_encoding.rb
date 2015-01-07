require 'securerandom'

class AudioEncoding < ActiveRecord::Base
  class EncodingJob
    @queue = "adhost"

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


  def codec
    key_parts[0]
  end

  def sample_rate
    key_parts[1].to_i
  end

  def extension
    nil
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
    "#{self.campaign_id}-#{self.fingerprint}.#{self.extension}"
  end


  def encode
    # we'll encode into a temp file and then move it into place

    mobj  = S3_BUCKET.objects[ self.campaign.master_file.path ]
    mtmp  = Tempfile.new('adhost',encoding:"ASCII-8BIT")
    mtmp.write mobj.read()
    mtmp.rewind()

    puts "mtmp length is #{ mtmp.length }"

    temp  = Tempfile.new(['adhost', ".#{self.extension}"],encoding:"ASCII-8BIT")

    begin
      master = FFMPEG::Movie.new(mtmp.path)
      transcode(master, temp)

      transcoded = FFMPEG::Movie.new(temp.path)
      return if !transcoded.valid?

      self.fingerprint = SecureRandom.hex(16)

      temp.rewind

      # now write it into place in our final location
      eobj = S3_BUCKET.objects[ self.path ]
      eobj.write temp

      self.save!
    rescue => e
      #self.destroy
      raise e
    ensure
      mtmp.close
      mtmp.unlink

      temp.close
      temp.unlink
    end
  end

  def s3_object
    if self.path
      S3_BUCKET.objects[self.path]
    end
  end

  private


  def key_parts
    @key_parts ||= self.stream_key.split("-")
  end

  def encode_async
    Resque.enqueue(EncodingJob, self.id)
  end

  def delete_file
    if obj = self.s3_object
      obj.delete
    end
  end
end
