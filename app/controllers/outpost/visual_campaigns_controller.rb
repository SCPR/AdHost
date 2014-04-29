class Outpost::VisualCampaignsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order_attribute   = "starts_at"
    l.default_order_direction   = Outpost::DESCENDING

    l.column :title
    l.column :output_key, header: "Key"
    l.column :active?, display: :display_boolean

    l.column :starts_at,
      :sortable                   => true,
      :default_order_direction    => Outpost::DESCENDING

    l.column :ends_at
    l.column :domains
  end


  private

  def form_params
    params.require(model.singular_route_key).permit(
      :title,
      :output_key,
      :markup,
      :domains,
      :starts_at,
      :ends_at,
      :cookie_key,
      :cookie_ttl_hours
    )
  end
end
