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

ActiveRecord::Schema.define(version: 20170416110454) do

  create_table "animes", force: :cascade do |t|
    t.string   "title"
    t.text     "image_url"
    t.integer  "episode_count"
    t.integer  "mal_id"
    t.text     "synonyms"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["mal_id"], name: "index_animes_on_mal_id"
  end

  create_table "mal_scores", force: :cascade do |t|
    t.integer  "anime_id"
    t.float    "score"
    t.integer  "rank"
    t.integer  "week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id", "week"], name: "index_mal_scores_on_anime_id_and_week"
    t.index ["anime_id"], name: "index_mal_scores_on_anime_id"
  end

  create_table "reddit_scores", force: :cascade do |t|
    t.integer  "anime_id"
    t.float    "score"
    t.integer  "rank"
    t.integer  "week"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id", "week"], name: "index_reddit_scores_on_anime_id_and_week"
    t.index ["anime_id"], name: "index_reddit_scores_on_anime_id"
  end

  create_table "user_scores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "anime_id"
    t.integer  "status"
    t.integer  "watched"
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id"], name: "index_user_scores_on_anime_id"
    t.index ["user_id"], name: "index_user_scores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "reddit_name"
    t.string   "mal_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
