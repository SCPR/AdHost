class User < ActiveRecord::Base
  outpost_model

  include Outpost::Model::Authorization
  include Outpost::Model::Authentication
end
