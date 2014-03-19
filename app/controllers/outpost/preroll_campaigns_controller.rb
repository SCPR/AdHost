class Outpost::PrerollCampaignsController < Outpost::ResourceController
  before_filter :get_record, only: [:upload]

  outpost_controller

  define_list do |l|
    l.default_order_attribute   = "starts_at"
    l.default_order_direction   = Outpost::DESCENDING

    l.column :title
    l.column :output_key, header: "Key"
    l.column :starts_at,
      :sortable                   => true,
      :default_order_direction    => Outpost::DESCENDING

    l.column :ends_at

    l.filter :output_key
  end
end
