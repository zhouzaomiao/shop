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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130611061319) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "tel"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "deleted_at"
  end

  create_table "admins", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "deleted_at"
  end

  create_table "attachments", :force => true do |t|
    t.string   "type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "obj"
    t.datetime "deleted_at"
  end

  create_table "big_categories", :force => true do |t|
    t.string   "name",       :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.boolean  "head_show"
    t.datetime "deleted_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "deleted_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "score"
    t.datetime "deleted_at"
  end

  create_table "middle_categories", :force => true do |t|
    t.integer  "big_category_id"
    t.string   "middle_category_name"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.datetime "deleted_at"
  end

  create_table "product_pictrues", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "deleted_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "num"
    t.string   "name"
    t.integer  "count"
    t.decimal  "cost",              :precision => 10, :scale => 0
    t.decimal  "price",             :precision => 10, :scale => 0
    t.datetime "up_time"
    t.boolean  "enabel",                                           :default => false
    t.text     "describe"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "small_category_id"
    t.boolean  "recommand"
    t.integer  "sale_count"
    t.datetime "deleted_at"
  end

  create_table "purchases", :force => true do |t|
    t.integer  "user_id"
    t.integer  "address_id"
    t.decimal  "total_price", :precision => 10, :scale => 0
    t.decimal  "protif",      :precision => 10, :scale => 0
    t.integer  "status"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "week"
    t.integer  "month"
    t.integer  "quarter"
    t.integer  "year"
    t.datetime "deleted_at"
  end

  create_table "shopping_carts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "purchase_id"
    t.decimal  "purchase_price", :precision => 10, :scale => 0
    t.decimal  "quantity",       :precision => 10, :scale => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "shopping_type"
    t.datetime "deleted_at"
  end

  create_table "small_categories", :force => true do |t|
    t.integer  "middle_category_id"
    t.string   "small_category_name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.datetime "deleted_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "is_activated",        :default => false
    t.boolean  "state",               :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.datetime "deleted_at"
  end

end
