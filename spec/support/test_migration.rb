class TestMigration < ActiveRecord::Migration
  def up
    create_table "auth_user", :force => true do |t|
      t.string   "name"
      t.string   "username"
      t.string   "email"
      t.boolean  "can_login",       :null => false
      t.boolean  "is_superuser",    :null => false
      t.datetime "last_login"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "password_digest"
    end
  end
end
