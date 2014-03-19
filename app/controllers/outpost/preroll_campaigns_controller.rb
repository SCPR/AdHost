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


  private

  def form_params
    params.require(model.singular_route_key).permit(
      :output_key,
      :title,
      :starts_at,
      :ends_at,
      :path_filter,
      :master_file
    )
  end
end
