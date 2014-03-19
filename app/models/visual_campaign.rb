class VisualCampaign < ActiveRecord::Base
  outpost_model

  scope :active, -> {
    where('starts_at <= :now and ends_at > :now', now: Time.now)
  }

  validates :title, presence: true
  validates :output_key, presence: true


  def allowed_domains
    self.domains.split(",")
  end
end
