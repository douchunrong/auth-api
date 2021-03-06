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

ActiveRecord::Schema.define(version: 20160327060417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.integer  "client_id",  null: false
    t.string   "token",      null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_access_tokens_on_account_id", using: :btree
    t.index ["client_id"], name: "index_access_tokens_on_client_id", using: :btree
    t.index ["token"], name: "index_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "access_tokens_scopes", id: false, force: :cascade do |t|
    t.integer "access_token_id", null: false
    t.integer "scope_id",        null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.string  "identifier", null: false
    t.string  "type",       null: false
    t.integer "client_id"
    t.index ["client_id"], name: "index_accounts_on_client_id", using: :btree
  end

  create_table "authorizations", force: :cascade do |t|
    t.integer  "account_id",   null: false
    t.integer  "client_id",    null: false
    t.string   "code",         null: false
    t.string   "nonce",        null: false
    t.string   "redirect_uri", null: false
    t.datetime "expires_at",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["account_id"], name: "index_authorizations_on_account_id", using: :btree
    t.index ["client_id"], name: "index_authorizations_on_client_id", using: :btree
    t.index ["code"], name: "index_authorizations_on_code", unique: true, using: :btree
  end

  create_table "authorizations_scopes", id: false, force: :cascade do |t|
    t.integer "authorization_id", null: false
    t.integer "scope_id",         null: false
  end

  create_table "clients", force: :cascade do |t|
    t.integer "user_account_id", null: false
    t.string  "redirect_uris",   null: false
    t.string  "identifier",      null: false
    t.string  "secret",          null: false
    t.string  "name",            null: false
    t.index ["identifier"], name: "index_clients_on_identifier", unique: true, using: :btree
    t.index ["user_account_id"], name: "index_clients_on_user_account_id", using: :btree
  end

  create_table "connect_internals", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string  "name",       null: false
    t.index ["account_id"], name: "index_connect_internals_on_account_id", using: :btree
    t.index ["name"], name: "index_connect_internals_on_name", unique: true, using: :btree
  end

  create_table "connect_parti", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string  "identifier", null: false
    t.index ["account_id"], name: "index_connect_parti_on_account_id", using: :btree
    t.index ["identifier"], name: "index_connect_parti_on_identifier", unique: true, using: :btree
  end

  create_table "id_tokens", force: :cascade do |t|
    t.integer  "account_id", null: false
    t.integer  "client_id",  null: false
    t.string   "nonce",      null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_id_tokens_on_account_id", using: :btree
    t.index ["client_id"], name: "index_id_tokens_on_client_id", using: :btree
  end

  create_table "scopes", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_scopes_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
