class VisualCampaign < ActiveRecord::Base
  include ActiveCheck

  outpost_model

  scope :active, -> {
    where('starts_at <= :now and ends_at > :now', now: Time.zone.now)
  }

  validates :title, presence: true
  validates :output_key, presence: true


  def allowed_domains
    self.domains.split(",").map(&:strip)
  end
end
