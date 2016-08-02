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

ActiveRecord::Schema.define(version: 20160802030715) do

  create_table "activities", force: :cascade do |t|
    t.integer  "action_type"
    t.integer  "user_id"
    t.integer  "target_id"
    t.string   "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "lessons", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.boolean  "is_completed"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "lessons", ["user_id", "category_id"], name: "index_lessons_on_user_id_and_category_id", unique: true
  add_index "lessons", ["user_id"], name: "index_lessons_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "results", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "word_id"
    t.integer  "word_answer_id"
    t.boolean  "is_correct"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "results", ["lesson_id", "word_id", "word_answer_id"], name: "index_results_on_lesson_id_and_word_id_and_word_answer_id", unique: true
  add_index "results", ["lesson_id"], name: "index_results_on_lesson_id"
  add_index "results", ["word_answer_id"], name: "index_results_on_word_answer_id"
  add_index "results", ["word_id"], name: "index_results_on_word_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone",               default: ""
    t.string   "address",             default: ""
    t.boolean  "sex",                 default: false
    t.boolean  "is_admin",            default: false
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true

  create_table "word_answers", force: :cascade do |t|
    t.string   "content"
    t.boolean  "is_correct"
    t.integer  "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "word_answers", ["word_id"], name: "index_word_answers_on_word_id"

  create_table "words", force: :cascade do |t|
    t.string   "content"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "words", ["category_id"], name: "index_words_on_category_id"

end
