s3_config = Hashie::Mash.new( Rails.application.secrets.s3 )

AWS_CONFIG = {
  access_key_id:      s3_config.access_key,
  secret_access_key:  s3_config.secret_key,
  s3_endpoint:        "s3.i.scprdev.org",
  ssl_verify_peer:    false,
  use_ssl:            false,
}

CarrierWave.configure do |config|
  config.aws_bucket       = s3_config.bucket
  config.aws_acl          = :public_read
  config.aws_credentials  = AWS_CONFIG
end

AWS.config(AWS_CONFIG)

S3 = AWS::S3.new
S3_BUCKET = S3.buckets[s3_config.bucket]