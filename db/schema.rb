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

ActiveRecord::Schema.define(version: 20140429192259) do

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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "preroller_outputs", ["key"], name: "index_preroller_outputs_on_key", using: :btree

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
