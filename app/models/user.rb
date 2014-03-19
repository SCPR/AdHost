class User < ActiveRecord::Base
  establish_connection "mercer_#{Rails.env}"
  self.table_name = "auth_user"

  include Outpost::Model::Authentication

  def is_admin?
    self.is_superuser
  end

  def can_manage?(*)
    true
  end
end
