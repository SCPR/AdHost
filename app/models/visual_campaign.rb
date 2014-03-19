class VisualCampaign < ActiveRecord::Base
  outpost_model

  scope :active, -> {
    where('starts_at <= :now and ends_at > :now', now: Time.now)
  }

  validates :title, presence: true
  validates :output_key, presence: true

  attr_accessible \
    :title,
    :output_key,
    :markup,
    :domains,
    :starts_at,
    :ends_at


  def allowed_domains
    self.domains.split(",")
  end
end
