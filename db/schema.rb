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

ActiveRecord::Schema[8.0].define(version: 2025_04_24_162356) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "benchmarks", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.jsonb "configuration", default: {}
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_benchmarks_on_name", unique: true
  end

  create_table "inputs", force: :cascade do |t|
    t.string "name", null: false
    t.text "content", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_inputs_on_name", unique: true
  end

  create_table "llms", force: :cascade do |t|
    t.string "name", null: false
    t.string "provider", null: false
    t.string "model_id", null: false
    t.jsonb "parameters", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["name"], name: "index_llms_on_name", unique: true
  end

  create_table "prompts", force: :cascade do |t|
    t.string "name", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_prompts_on_name", unique: true
  end

  create_table "runs", force: :cascade do |t|
    t.bigint "input_id", null: false
    t.bigint "prompt_id", null: false
    t.bigint "llm_id", null: false
    t.text "response"
    t.float "latency"
    t.integer "tokens_in"
    t.integer "tokens_out"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["input_id", "prompt_id", "llm_id"], name: "index_runs_on_input_prompt_llm"
    t.index ["input_id"], name: "index_runs_on_input_id"
    t.index ["llm_id"], name: "index_runs_on_llm_id"
    t.index ["prompt_id"], name: "index_runs_on_prompt_id"
    t.index ["status"], name: "index_runs_on_status"
  end

  add_foreign_key "runs", "inputs"
  add_foreign_key "runs", "llms"
  add_foreign_key "runs", "prompts"
end
