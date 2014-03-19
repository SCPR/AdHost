class Outpost::VisualCampaignsController < Outpost::ResourceController
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
    l.column :domains
  end
end
