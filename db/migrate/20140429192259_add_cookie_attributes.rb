class AddCookieAttributes < ActiveRecord::Migration
  def change
    add_column :visual_campaigns, :cookie_key, :string
    add_column :visual_campaigns, :cookie_ttl_hours, :integer
  end
end
