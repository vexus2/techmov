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

ActiveRecord::Schema.define(:version => 20121023071102) do

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.string   "identifier"
    t.string   "site"
    t.string   "description"
    t.string   "thumbnail_url"
    t.datetime "first_retrieve"
    t.string   "length"
    t.integer  "movie_size"
    t.integer  "view_counter"
    t.boolean  "embeddable"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "url"
    t.boolean  "del_flg",         :null => false
    t.boolean  "use_flg",         :null => false
    t.integer  "tag_id",          :null => false
    t.integer  "comment_counter"
    t.integer  "mylist_counter"
  end

  create_table "mylist_details", :force => true do |t|
    t.integer  "omniuser_id"
    t.integer  "movie_id"
    t.boolean  "del_flg"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "omniusers", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "tag"
    t.boolean  "del_flg"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
