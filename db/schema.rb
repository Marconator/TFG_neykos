# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_10_194956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "adminpack"
  enable_extension "plpgsql"

  create_table "alert_types", force: :cascade do |t|
    t.string "name"
    t.string "column_name"
  end

  create_table "alerts", force: :cascade do |t|
    t.boolean "triggered", default: false
    t.boolean "notify_stability"
    t.bigint "alert_type_id"
    t.text "description"
    t.float "persistence"
    t.float "limit"
    t.boolean "sign"
    t.bigint "client_id"
    t.bigint "notification_level_id"
    t.string "source"
    t.string "element"
    t.string "element_id"
    t.bigint "gateway_id"
    t.datetime "persistence_since"
    t.boolean "notify_app"
    t.boolean "notify_email"
    t.boolean "notify_slack"
    t.boolean "deleted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alert_type_id"], name: "index_alerts_on_alert_type_id"
    t.index ["client_id"], name: "index_alerts_on_client_id"
    t.index ["gateway_id"], name: "index_alerts_on_gateway_id"
    t.index ["notification_level_id"], name: "index_alerts_on_notification_level_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "client_id"
  end

  create_table "device_status", force: :cascade do |t|
    t.integer "status"
    t.integer "power"
    t.float "voltage"
    t.float "temperature"
    t.integer "dcId"
    t.bigint "device_id"
    t.datetime "created_at"
    t.index ["device_id"], name: "index_device_status_on_device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.bigint "gateway_id"
    t.index ["gateway_id"], name: "index_devices_on_gateway_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_emails_on_client_id"
  end

  create_table "engine_status", force: :cascade do |t|
    t.integer "status"
    t.bigint "engine_id"
    t.datetime "created_at"
    t.index ["engine_id"], name: "index_engine_status_on_engine_id"
  end

  create_table "engines", force: :cascade do |t|
    t.string "name"
    t.bigint "gateway_id"
    t.index ["gateway_id"], name: "index_engines_on_gateway_id"
  end

  create_table "gateway_alive", force: :cascade do |t|
    t.string "gateway_id"
    t.datetime "created_at"
  end

  create_table "gateways", force: :cascade do |t|
    t.string "gateway_id"
    t.bigint "client_id"
    t.index ["client_id"], name: "index_gateways_on_client_id"
  end

  create_table "hardware", force: :cascade do |t|
    t.string "hardware_id"
    t.bigint "gateway_id"
    t.float "cpu_percent"
    t.float "memory_available"
    t.float "memory_total"
    t.float "memory_percent"
    t.float "disk_free"
    t.float "disk_total"
    t.float "disk_percent"
    t.float "temperature"
    t.datetime "updated_at"
    t.index ["gateway_id"], name: "index_hardware_on_gateway_id"
  end

  create_table "notification_levels", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean "triggered"
    t.boolean "notify_app"
    t.boolean "notify_email"
    t.boolean "notify_slack"
    t.integer "alert_id"
    t.string "message"
    t.string "email_message_id"
    t.bigint "client_id"
    t.bigint "notification_level_id"
    t.bigint "gateway_id"
    t.bigint "alert_type_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["alert_type_id"], name: "index_notifications_on_alert_type_id"
    t.index ["client_id"], name: "index_notifications_on_client_id"
    t.index ["gateway_id"], name: "index_notifications_on_gateway_id"
    t.index ["notification_level_id"], name: "index_notifications_on_notification_level_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.string "sensor_id"
    t.bigint "device_id"
    t.index ["device_id"], name: "index_sensors_on_device_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alerts", "alert_types"
  add_foreign_key "alerts", "clients"
  add_foreign_key "alerts", "gateways"
  add_foreign_key "alerts", "notification_levels"
  add_foreign_key "device_status", "devices"
  add_foreign_key "devices", "gateways"
  add_foreign_key "emails", "clients"
  add_foreign_key "engine_status", "engines"
  add_foreign_key "engines", "gateways"
  add_foreign_key "gateways", "clients"
  add_foreign_key "notifications", "alert_types"
  add_foreign_key "notifications", "clients"
  add_foreign_key "notifications", "gateways"
  add_foreign_key "notifications", "notification_levels"
  add_foreign_key "sensors", "devices"
end
