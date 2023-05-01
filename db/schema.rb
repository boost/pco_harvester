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

ActiveRecord::Schema[7.0].define(version: 2023_04_25_223829) do
  create_table "content_partners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extraction_definitions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "format", null: false
    t.string "base_url", null: false
    t.integer "throttle", default: 0, null: false
    t.string "pagination_type", null: false
    t.string "page_parameter"
    t.string "per_page_parameter"
    t.integer "page"
    t.integer "per_page"
    t.string "total_selector"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "content_partner_id", null: false
    t.index ["content_partner_id", "name"], name: "index_extraction_definitions_on_content_partner_id_and_name", unique: true
    t.index ["content_partner_id"], name: "index_extraction_definitions_on_content_partner_id"
    t.index ["name"], name: "index_extraction_definitions_on_name"
  end

  create_table "jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "status", default: "queued"
    t.string "result_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "extraction_definition_id", null: false
    t.string "kind", default: "full", null: false
    t.index ["extraction_definition_id"], name: "index_jobs_on_extraction_definition_id"
  end

end
