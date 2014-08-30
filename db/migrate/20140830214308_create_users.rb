class CreateUsers < ActiveRecord::Migration
  def change
    create_table "permissions" do |t|
      t.string   "resource"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "permissions", ["resource"], name: "index_permissions_on_resource", using: :btree

    create_table "user_permissions" do |t|
      t.integer  "user_id"
      t.integer  "permission_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "user_permissions", ["permission_id"], name: "index_user_permissions_on_permission_id", using: :btree
    add_index "user_permissions", ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id", using: :btree
    add_index "user_permissions", ["user_id"], name: "index_user_permissions_on_user_id", using: :btree

    create_table "users" do |t|
      t.string   "name"
      t.string   "username"
      t.string   "email"
      t.string   "password_digest"
      t.boolean  "can_login", default: true
      t.boolean  "is_superuser", default: false
      t.datetime "last_login"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "users", ["username", "can_login"]

    Outpost.config.registered_models.each do |m|
      Permission.create(resource: m)
    end
  end
end
