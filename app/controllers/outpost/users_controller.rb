class Outpost::UsersController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order_attribute   = "name"
    l.default_order_direction   = Outpost::ASCENDING

    l.column :name
    l.column :username
    l.column :can_login, header: "Can Login?"
    l.column :is_superuser, header: "Superuser?"
    l.column :last_login
  end


  def authorize_resource
    if @record
      if current_user == @record && %w{show edit update}.include?(action_name)
        return true
      end
    end

    super
  end


  private

  def form_params
    permitted = [:name, :email, :username, :password, :password_confirmation]

    if current_user.is_superuser?
      permitted += [:can_login, :is_superuser, { permission_ids: [] }]
    end

    params.require(model.singular_route_key).permit(*permitted)
  end
end
