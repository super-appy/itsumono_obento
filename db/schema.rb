# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_26_074726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarked_recipes", force: :cascade do |t|
    t.integer "status"
    t.text "comment"
    t.integer "repeat"
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_bookmarked_recipes_on_recipe_id"
    t.index ["user_id"], name: "index_bookmarked_recipes_on_user_id"
  end

  create_table "like_lunchbox_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lunchbox_log_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lunchbox_log_id"], name: "index_like_lunchbox_logs_on_lunchbox_log_id"
    t.index ["user_id"], name: "index_like_lunchbox_logs_on_user_id"
  end

  create_table "lunchbox_logs", force: :cascade do |t|
    t.date "cooked_date"
    t.string "original_menu"
    t.text "comment"
    t.string "image"
    t.integer "published_status"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lunchbox_logs_on_user_id"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.string "name"
    t.string "quantity"
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_tags", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_tags_on_recipe_id"
    t.index ["tag_id"], name: "index_recipe_tags_on_tag_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.integer "time_required"
    t.integer "taste"
    t.text "api_ingredients"
    t.text "api_steps"
    t.string "taste_tag_time"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taste_tag_time"], name: "index_recipes_on_taste_tag_time", unique: true
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "category"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "name"
    t.string "avator"
    t.integer "line_registerd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bookmarked_recipes", "recipes"
  add_foreign_key "bookmarked_recipes", "users"
  add_foreign_key "like_lunchbox_logs", "lunchbox_logs"
  add_foreign_key "like_lunchbox_logs", "users"
  add_foreign_key "lunchbox_logs", "users"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_tags", "recipes"
  add_foreign_key "recipe_tags", "tags"
  add_foreign_key "recipes", "users"
end