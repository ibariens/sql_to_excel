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

ActiveRecord::Schema.define(version: 20141230162233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_variables", force: :cascade do |t|
    t.string   "name"
    t.text     "stored_sql"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_variables", ["name"], name: "index_custom_variables_on_name", unique: true, using: :btree

  create_table "file_names", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "user_id"
    t.string   "last_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "file_names", ["report_id", "user_id"], name: "index_file_names_on_report_id_and_user_id", unique: true, using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_reports", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups_reports", ["report_id", "group_id"], name: "index_groups_reports_on_report_id_and_group_id", unique: true, using: :btree

  create_table "owners", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "owners", ["report_id", "user_id"], name: "index_owners_on_report_id_and_user_id", unique: true, using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "name"
    t.text     "stored_sql"
    t.string   "file_name"
    t.float    "execution_time"
    t.datetime "last_execution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sql_file_id",    null: false
  end

  add_index "reports", ["sql_file_id"], name: "index_reports_on_sql_file_id", unique: true, using: :btree

  create_table "sql_files", force: :cascade do |t|
    t.string   "name"
    t.string   "directory"
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "display_name"
    t.string   "password_hash"
    t.string   "password_salt"
    t.integer  "hierarchy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group"
  end

end
