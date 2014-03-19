if (Rails.env == "scprdev" || Rails.env == "production")
  FFMPEG.ffmpeg_binary = "/usr/local/bin/ffmpeg"
end
