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

ActiveRecord::Schema.define(:version => 20151108103744) do

  create_table "ahoy_events", :force => true do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "properties"
    t.datetime "time"
    t.string   "group"
  end

  add_index "ahoy_events", ["time"], :name => "index_ahoy_events_on_time"
  add_index "ahoy_events", ["user_id"], :name => "index_ahoy_events_on_user_id"
  add_index "ahoy_events", ["visit_id"], :name => "index_ahoy_events_on_visit_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "games", :force => true do |t|
    t.integer  "number",                                      :null => false
    t.integer  "match_day_id",                                :null => false
    t.integer  "player_id",                                   :null => false
    t.integer  "frame01_result1",              :default => 0, :null => false
    t.string   "frame01_state1",  :limit => 1,                :null => false
    t.integer  "frame01_result2",              :default => 0
    t.string   "frame01_state2",  :limit => 1
    t.integer  "frame02_result1",              :default => 0, :null => false
    t.string   "frame02_state1",  :limit => 1,                :null => false
    t.integer  "frame02_result2",              :default => 0
    t.string   "frame02_state2",  :limit => 1
    t.integer  "frame03_result1",              :default => 0, :null => false
    t.string   "frame03_state1",  :limit => 1,                :null => false
    t.integer  "frame03_result2",              :default => 0
    t.string   "frame03_state2",  :limit => 1
    t.integer  "frame04_result1",              :default => 0, :null => false
    t.string   "frame04_state1",  :limit => 1,                :null => false
    t.integer  "frame04_result2",              :default => 0
    t.string   "frame04_state2",  :limit => 1
    t.integer  "frame05_result1",              :default => 0, :null => false
    t.string   "frame05_state1",  :limit => 1,                :null => false
    t.integer  "frame05_result2",              :default => 0
    t.string   "frame05_state2",  :limit => 1
    t.integer  "frame06_result1",              :default => 0, :null => false
    t.string   "frame06_state1",  :limit => 1,                :null => false
    t.integer  "frame06_result2",              :default => 0
    t.string   "frame06_state2",  :limit => 1
    t.integer  "frame07_result1",              :default => 0, :null => false
    t.string   "frame07_state1",  :limit => 1,                :null => false
    t.integer  "frame07_result2",              :default => 0
    t.string   "frame07_state2",  :limit => 1
    t.integer  "frame08_result1",              :default => 0, :null => false
    t.string   "frame08_state1",  :limit => 1,                :null => false
    t.integer  "frame08_result2",              :default => 0
    t.string   "frame08_state2",  :limit => 1
    t.integer  "frame09_result1",              :default => 0, :null => false
    t.string   "frame09_state1",  :limit => 1,                :null => false
    t.integer  "frame09_result2",              :default => 0
    t.string   "frame09_state2",  :limit => 1
    t.integer  "frame10_result1",              :default => 0, :null => false
    t.string   "frame10_state1",  :limit => 1,                :null => false
    t.integer  "frame10_result2",              :default => 0, :null => false
    t.string   "frame10_state2",  :limit => 1,                :null => false
    t.integer  "frame10_result3",              :default => 0
    t.string   "frame10_state3",  :limit => 1
    t.integer  "points",                       :default => 0, :null => false
    t.integer  "cleared_frames",               :default => 0, :null => false
    t.integer  "strikes",                      :default => 0, :null => false
    t.integer  "spares",                       :default => 0, :null => false
    t.integer  "fouls",                        :default => 0, :null => false
    t.integer  "splits",                       :default => 0, :null => false
    t.integer  "cleared_splits",               :default => 0, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "match_days", :force => true do |t|
    t.date     "match_day",   :null => false
    t.integer  "location_id", :null => false
    t.integer  "category_id", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "visits", :force => true do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude",         :precision => 10, :scale => 0
    t.decimal  "longitude",        :precision => 10, :scale => 0
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"

end
