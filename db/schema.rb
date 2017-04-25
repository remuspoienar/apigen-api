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

ActiveRecord::Schema.define(version: 20170422153625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_associations", force: :cascade do |t|
    t.string   "resource_name"
    t.string   "resource_label"
    t.string   "kind"
    t.integer  "api_resource_id"
    t.text     "advanced_options"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["api_resource_id"], name: "index_api_associations_on_api_resource_id", using: :btree
  end

  create_table "api_attributes", force: :cascade do |t|
    t.integer  "api_resource_id"
    t.string   "name"
    t.string   "db_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["api_resource_id"], name: "index_api_attributes_on_api_resource_id", using: :btree
  end

  create_table "api_projects", force: :cascade do |t|
    t.string   "name"
    t.integer  "created_by_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["created_by_id"], name: "index_api_projects_on_created_by_id", using: :btree
  end

  create_table "api_resources", force: :cascade do |t|
    t.string   "name"
    t.integer  "api_project_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["api_project_id"], name: "index_api_resources_on_api_project_id", using: :btree
  end

  create_table "api_users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_api_users_on_email", using: :btree
  end

  create_table "api_validations", force: :cascade do |t|
    t.integer  "api_attribute_id"
    t.string   "trait"
    t.text     "advanced_options"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["api_attribute_id"], name: "index_api_validations_on_api_attribute_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.text     "token"
    t.integer  "api_user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["api_user_id"], name: "index_sessions_on_api_user_id", using: :btree
  end

  add_foreign_key "api_associations", "api_resources"
  add_foreign_key "api_attributes", "api_resources"
  add_foreign_key "api_projects", "api_users", column: "created_by_id"
  add_foreign_key "api_resources", "api_projects"
  add_foreign_key "api_validations", "api_attributes"
  add_foreign_key "sessions", "api_users"
end
