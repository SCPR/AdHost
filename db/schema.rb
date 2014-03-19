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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140319021225) do

  create_table "preroller_audio_encodings", :force => true do |t|
    t.integer  "campaign_id",                    :null => false
    t.string   "stream_key"
    t.string   "fingerprint"
    t.string   "extension"
    t.integer  "size"
    t.integer  "duration"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "type"
    t.integer  "sample_rate"
    t.integer  "bitrate"
    t.integer  "profile"
    t.integer  "channels"
    t.boolean  "is_master",   :default => false
  end

  add_index "preroller_audio_encodings", ["campaign_id"], :name => "index_preroller_audio_encodings_on_campaign_id"
  add_index "preroller_audio_encodings", ["is_master"], :name => "index_preroller_audio_encodings_on_is_master"
  add_index "preroller_audio_encodings", ["sample_rate", "bitrate", "channels"], :name => "audio_metadata"

  create_table "preroller_campaigns", :force => true do |t|
    t.string   "title",                          :null => false
    t.string   "metatitle"
    t.boolean  "active",      :default => false, :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "output_id"
    t.string   "path_filter"
    t.string   "ua_filter"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "output_key"
    t.string   "master_file"
  end

  add_index "preroller_campaigns", ["created_at"], :name => "index_preroller_campaigns_on_created_at"
  add_index "preroller_campaigns", ["output_key"], :name => "index_preroller_campaigns_on_key"
  add_index "preroller_campaigns", ["path_filter"], :name => "index_preroller_campaigns_on_path_filter"
  add_index "preroller_campaigns", ["starts_at", "ends_at"], :name => "index_preroller_campaigns_on_starts_at_and_ends_at"

  create_table "preroller_outputs", :force => true do |t|
    t.string   "key",         :null => false
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "preroller_outputs", ["key"], :name => "index_preroller_outputs_on_key"

  create_table "visual_campaigns", :force => true do |t|
    t.string   "title"
    t.string   "output_key"
    t.text     "markup"
    t.string   "domains"
    t.boolean  "is_active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  add_index "visual_campaigns", ["output_key"], :name => "index_visual_campaigns_on_key"
  add_index "visual_campaigns", ["starts_at", "ends_at"], :name => "index_visual_campaigns_on_starts_at_and_ends_at"

end
