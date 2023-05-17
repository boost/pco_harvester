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

ActiveRecord::Schema[7.0].define(version: 2023_05_16_222755) do
  create_table "content_partners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destinations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "api_key", null: false
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

  create_table "extraction_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "extraction_definition_id", null: false
    t.integer "kind", default: 0, null: false
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.text "error_message"
    t.bigint "harvest_job_id"
    t.index ["extraction_definition_id"], name: "index_extraction_jobs_on_extraction_definition_id"
    t.index ["harvest_job_id"], name: "index_extraction_jobs_on_harvest_job_id"
  end

  create_table "fields", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "block"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transformation_definition_id", null: false
    t.index ["transformation_definition_id"], name: "index_fields_on_transformation_definition_id"
  end

  create_table "harvest_definitions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "content_partner_id"
    t.bigint "extraction_definition_id"
    t.bigint "extraction_job_id"
    t.bigint "transformation_definition_id"
    t.bigint "destination_id"
    t.index ["content_partner_id"], name: "index_harvest_definitions_on_content_partner_id"
    t.index ["destination_id"], name: "index_harvest_definitions_on_destination_id"
    t.index ["extraction_definition_id"], name: "index_harvest_definitions_on_extraction_definition_id"
    t.index ["extraction_job_id"], name: "index_harvest_definitions_on_extraction_job_id"
    t.index ["transformation_definition_id"], name: "index_harvest_definitions_on_transformation_definition_id"
  end

  create_table "harvest_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status"
    t.integer "kind", default: 0, null: false
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "harvest_definition_id"
    t.index ["harvest_definition_id"], name: "index_harvest_jobs_on_harvest_definition_id"
  end

  create_table "load_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status"
    t.integer "kind", default: 0, null: false
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.integer "records_loaded", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "harvest_job_id"
    t.integer "page", default: 1, null: false
    t.index ["harvest_job_id"], name: "index_load_jobs_on_harvest_job_id"
  end

  create_table "transformation_definitions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_selector", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "content_partner_id", null: false
    t.bigint "extraction_job_id", null: false
    t.bigint "original_transformation_definition_id"
    t.index ["content_partner_id"], name: "index_transformation_definitions_on_content_partner_id"
    t.index ["extraction_job_id"], name: "index_transformation_definitions_on_extraction_job_id"
    t.index ["name"], name: "index_transformation_definitions_on_name"
    t.index ["original_transformation_definition_id"], name: "index_tds_on_original_td_id"
  end

  create_table "transformation_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status"
    t.integer "kind", default: 0, null: false
    t.integer "page"
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.text "error_message"
    t.integer "records_transformed", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "transformation_definition_id"
    t.bigint "harvest_job_id"
    t.index ["harvest_job_id"], name: "index_transformation_jobs_on_harvest_job_id"
    t.index ["transformation_definition_id"], name: "index_transformation_jobs_on_transformation_definition_id"
  end

end
