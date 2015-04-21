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

ActiveRecord::Schema.define(:version => 20150421160307) do

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

end
