class PrerollCampaign < ActiveRecord::Base
  class InvalidAudioError < StandardError
  end

  # We need to limit allowed stream keys, otherwise we would be allowing
  # a theoretically inifinite number of preroll files to be created
  # by anyone with the preroll endpoint.
  VALID_STREAM_KEYS = [
    # MP3 key: (codec)-(samplerate)-(bitrate)-(mono/stereo)
    # Example: mp3-44100-64-m, aac-44100-48-m, etc
    /\Amp3-(44100|24000|22050)-(64|48)-(m|s)\z/,

    # AAC key: (codec)-(samplerate)-(profile index)-(number of channels)
    # Example: aac-44100-2-1, aac-44100-3-2, etc
    /\Aaac-(44100|24000|22050)-(1|2)-(1|2)\z/
  ]

  self.table_name = "preroller_campaigns"
  outpost_model

  has_many :encodings,
    :class_name   => "AudioEncoding",
    :foreign_key  => "campaign_id",
    :dependent    => :destroy

  scope :active, -> {
    where("starts_at <= :now and ends_at > :now", now: Time.now)
  }

  validates :title, presence: true

  mount_uploader :master_file, AudioUploader
  after_update :clear_encodings, :if => -> { self.master_file_changed? }


  class << self
    # For outpost
    def output_keys_select_collection
      PrerollCampaign.order("output_key").pluck("distinct output_key")
    end

    # Verify that the passed-in stream key is allowed.
    # Returns the key if it is allowed, or raises InvalidAudioError if not.
    def verify_stream_key(key)
      if VALID_STREAM_KEYS.find { |regex| key.match(regex) }
        return key
      else
        raise InvalidAudioError
      end
    end
  end


  # Takes a stream key and returns a file path
  # MP3 Stream key format: (codec)-(samplerate)-(bitrate)-(m/s)
  # AAC Stream key format: (codec)-(samplerate)-(profile)-(1/2)
  # For instance: mp3-44100-64-m, aac-44100-48-m, etc
  def file_for_stream_key(key)
    PrerollCampaign.verify_stream_key(key)

    if encoding = self.encodings.find_by_stream_key(key)
      return encoding.path
    else
      type = AudioEncoding::TYPES[key.split("-")[0]]

      # If it's getting created for the first time, then we don't want
      # the user to wait while it gets encoded, so they don't have to
      # listen to preroll. Next time it should be ready to go, for now
      # we'll return nil.
      self.encodings.create(type: type, stream_key: key)
      return nil
    end
  end


  private

  def clear_encodings
    self.encodings.each(&:destroy)
  end
end
