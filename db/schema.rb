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

ActiveRecord::Schema.define(version: 20150725104904) do

  create_table "colors", force: :cascade do |t|
    t.string   "hex"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "creations", force: :cascade do |t|
    t.integer  "lm_id"
    t.string   "imgs"
    t.string   "categs"
    t.string   "title"
    t.string   "subtitle"
    t.text     "desc"
    t.string   "tags"
    t.string   "materials"
    t.string   "colors"
    t.string   "styles"
    t.string   "events"
    t.string   "dest"
    t.string   "prices"
    t.string   "deliveries"
    t.string   "options"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "state",      default: "published"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "check_little_ids", default: false
  end

end
