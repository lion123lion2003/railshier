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

ActiveRecord::Schema.define(:version => 20150128032751) do

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "user_id",  :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_ids", :unique => true

  create_table "licenses", :force => true do |t|
    t.string   "name",                  :default => "", :null => false
    t.string   "keyword",               :default => "", :null => false
    t.integer  "author_id",             :default => 0,  :null => false
    t.integer  "requestor_id",          :default => 0,  :null => false
    t.string   "hostid",                :default => "", :null => false
    t.datetime "effective_date"
    t.datetime "request_date"
    t.string   "customer_organization", :default => "", :null => false
    t.string   "customer_manager",      :default => "", :null => false
    t.string   "project_name",          :default => "", :null => false
    t.string   "usage",                 :default => "", :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "licenses", ["author_id"], :name => "index_licenses_on_author_id"

  create_table "product_families", :force => true do |t|
    t.string   "name",        :default => "", :null => false
    t.string   "description", :default => "", :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "product_families", ["name"], :name => "index_product_families_on_name"

  create_table "product_licenses", :force => true do |t|
    t.integer  "license_id",  :default => 0, :null => false
    t.integer  "product_id",  :default => 0, :null => false
    t.integer  "quantity",    :default => 0, :null => false
    t.datetime "expire_date"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "product_licenses", ["license_id", "product_id"], :name => "index_product_licenses_on_license_id_and_product_id", :unique => true

  create_table "products", :force => true do |t|
    t.integer  "family_id",        :default => 0,  :null => false
    t.string   "number",           :default => "", :null => false
    t.string   "name",             :default => "", :null => false
    t.integer  "status",           :default => 1,  :null => false
    t.datetime "end_support_date"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "products", ["family_id"], :name => "index_products_on_family_id"
  add_index "products", ["number"], :name => "index_products_on_number"

  create_table "users", :force => true do |t|
    t.string   "login",                                :default => "",    :null => false
    t.string   "email",                                :default => "",    :null => false
    t.integer  "status",                               :default => 1,     :null => false
    t.boolean  "admin",                                :default => false, :null => false
    t.string   "firstname",              :limit => 30, :default => "",    :null => false
    t.string   "lastname",               :limit => 30, :default => "",    :null => false
    t.boolean  "email_notification",                   :default => true,  :null => false
    t.string   "type",                                 :default => "",    :null => false
    t.string   "encrypted_password",                   :default => "",    :null => false
    t.integer  "source",                               :default => 0,     :null => false
    t.integer  "primary_id",                           :default => 0,     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login"

end
