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

ActiveRecord::Schema.define(version: 20160616105437) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "citext"

  create_table "embed_apps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "source_url",                 null: false
    t.jsonb    "settings",    default: "{}"
    t.text     "source_code"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "embeds", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "embedable_id"
    t.string   "embedable_type"
    t.string   "title",                          null: false
    t.string   "slug"
    t.text     "summary"
    t.text     "content"
    t.integer  "source_type",    default: 0
    t.integer  "status",         default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "published",      default: false
    t.string   "thumbnail_url"
    t.index ["embedable_id", "embedable_type"], name: "index_embeds_on_source_and_embedable_type", unique: true, using: :btree
    t.index ["source_type"], name: "index_embeds_on_source_type", using: :btree
    t.index ["status"], name: "index_embeds_on_status", using: :btree
  end

  create_table "photos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "source_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_settings", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.string   "token"
    t.string   "url"
    t.boolean  "listener"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_service_settings_on_name", unique: true, using: :btree
  end

  create_table "sources", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "acronym"
    t.string   "url"
    t.string   "logo_url"
    t.boolean  "partner",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
