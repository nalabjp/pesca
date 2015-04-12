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

ActiveRecord::Schema.define(version: 20150107150328) do

  create_table "events", force: :cascade do |t|
    t.string   "provider",    limit: 32,       null: false
    t.string   "event_id",    limit: 16,       null: false
    t.string   "title",       limit: 255,      null: false
    t.text     "description", limit: 16777215
    t.text     "catch",       limit: 16777215
    t.string   "address",     limit: 255
    t.string   "event_url",   limit: 255,      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "events", ["provider", "event_id"], name: "unique_on_provider_and_event_id", unique: true, using: :btree

end
