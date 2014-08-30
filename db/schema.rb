# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140830214308) do

  create_table "permissions", force: true do |t|
    t.string   "resource"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["resource"], name: "index_permissions_on_resource", using: :btree

  create_table "preroller_audio_encodings", force: true do |t|
    t.integer  "campaign_id", null: false
    t.string   "stream_key"
    t.string   "fingerprint"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "type"
  end

  add_index "preroller_audio_encodings", ["campaign_id"], name: "index_preroller_audio_encodings_on_campaign_id", using: :btree
  add_index "preroller_audio_encodings", ["stream_key"], name: "index_preroller_audio_encodings_on_stream_key", using: :btree
  add_index "preroller_audio_encodings", ["type"], name: "index_preroller_audio_encodings_on_type", using: :btree

  create_table "preroller_campaigns", force: true do |t|
    t.string   "title",       null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "path_filter"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "output_key"
    t.string   "master_file"
  end

  add_index "preroller_campaigns", ["created_at"], name: "index_preroller_campaigns_on_created_at", using: :btree
  add_index "preroller_campaigns", ["output_key"], name: "index_preroller_campaigns_on_output_key", using: :btree
  add_index "preroller_campaigns", ["path_filter"], name: "index_preroller_campaigns_on_path_filter", using: :btree
  add_index "preroller_campaigns", ["starts_at", "ends_at"], name: "index_preroller_campaigns_on_starts_at_and_ends_at", using: :btree

  create_table "preroller_outputs", force: true do |t|
    t.string   "key",         null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_permissions", ["permission_id"], name: "index_user_permissions_on_permission_id", using: :btree
  add_index "user_permissions", ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id", using: :btree
  add_index "user_permissions", ["user_id"], name: "index_user_permissions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "can_login"
    t.boolean  "is_superuser"
    t.datetime "last_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username", "can_login"], name: "index_users_on_username_and_can_login", using: :btree

  create_table "visual_campaigns", force: true do |t|
    t.string   "title"
    t.string   "output_key"
    t.text     "markup"
    t.string   "domains"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "cookie_key"
    t.integer  "cookie_ttl_hours"
  end

  add_index "visual_campaigns", ["output_key"], name: "index_visual_campaigns_on_output_key", using: :btree
  add_index "visual_campaigns", ["starts_at", "ends_at"], name: "index_visual_campaigns_on_starts_at_and_ends_at", using: :btree

end
