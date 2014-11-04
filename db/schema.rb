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

ActiveRecord::Schema.define(version: 20141103224404) do

  create_table "images", force: true do |t|
    t.integer "thought_id"
    t.string  "image_link", limit: 128
  end

  add_index "images", ["thought_id"], name: "index_images_on_thought_id"

  create_table "relations", id: false, force: true do |t|
    t.integer "follower_id"
    t.integer "followee_id"
  end

  add_index "relations", ["followee_id"], name: "index_relations_on_followee_id"
  add_index "relations", ["follower_id"], name: "index_relations_on_follower_id"

  create_table "thoughts", force: true do |t|
    t.string   "title",      limit: 64
    t.text     "body"
    t.boolean  "shout",                 default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thoughts", ["user_id"], name: "index_thoughts_on_user_id"

  create_table "users", force: true do |t|
    t.string   "full_name",       limit: 128,                 null: false
    t.string   "username",        limit: 16,                  null: false
    t.string   "password_digest"
    t.string   "avatar",          limit: 64
    t.string   "email",           limit: 64,                  null: false
    t.boolean  "email_confirmed",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gravatar_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
