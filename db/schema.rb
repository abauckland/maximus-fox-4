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

ActiveRecord::Schema.define(version: 20140527201109) do

  create_table "abouts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "image"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cawssections", force: true do |t|
    t.string   "ref"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cawssubsections", force: true do |t|
    t.integer  "cawssection_id"
    t.integer  "ref"
    t.string   "text"
    t.integer  "guidepdf_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charcs", force: true do |t|
    t.integer  "instance_id"
    t.integer  "perform_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clauseproducts", force: true do |t|
    t.integer  "clause_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clauserefs", force: true do |t|
    t.integer  "clausetype_id"
    t.integer  "clause_no"
    t.integer  "subclause"
    t.integer  "subsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clauses", force: true do |t|
    t.integer  "clauseref_id"
    t.integer  "clausetitle_id"
    t.integer  "guidenote_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clausetitles", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clausetypes", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.string   "client_logo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "www"
    t.string   "reg_address"
    t.integer  "reg_number"
    t.string   "reg_name"
    t.string   "reg_location"
    t.integer  "read_term"
    t.integer  "category"
    t.string   "logo"
    t.integer  "no_licence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "descripts", force: true do |t|
    t.integer  "identity_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featurecontents", force: true do |t|
    t.integer  "feature_id"
    t.integer  "order"
    t.string   "title"
    t.text     "text"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", force: true do |t|
    t.string   "title"
    t.string   "text"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guidenotes", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", force: true do |t|
    t.string   "title"
    t.string   "video"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "identkey_id"
    t.integer  "identvalue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identkeys", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identtxts", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identvalues", force: true do |t|
    t.integer  "identtxt_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instances", force: true do |t|
    t.integer  "product_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lineclausetypes", force: true do |t|
    t.integer  "clausetype_id"
    t.integer  "linetype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "linetypes", force: true do |t|
    t.string   "ref"
    t.string   "description"
    t.string   "example"
    t.integer  "txt1"
    t.integer  "txt2"
    t.integer  "txt3"
    t.integer  "txt4"
    t.integer  "txt5"
    t.integer  "txt6"
    t.integer  "identity"
    t.integer  "perform"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performkeys", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performs", force: true do |t|
    t.integer  "performskey_id"
    t.integer  "performvalue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performtxts", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "performvalues", force: true do |t|
    t.integer  "valuetype_id"
    t.integer  "performtxt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planfeatures", force: true do |t|
    t.integer  "priceplan_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priceplans", force: true do |t|
    t.string   "name"
    t.string   "plan"
    t.integer  "sign_up"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prints", force: true do |t|
    t.integer  "project_id"
    t.integer  "revision_id"
    t.integer  "user_id"
    t.string   "print"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "printsettings", force: true do |t|
    t.integer  "project_id"
    t.integer  "font_style"
    t.integer  "font_size"
    t.integer  "structure"
    t.integer  "prelim"
    t.integer  "page_number"
    t.integer  "client_detail"
    t.integer  "client_logo"
    t.integer  "project_detail"
    t.integer  "project_image"
    t.integer  "company_detail"
    t.integer  "header_project"
    t.integer  "header_client"
    t.integer  "header_document"
    t.integer  "header_logo"
    t.integer  "footer_detail"
    t.integer  "footer_author"
    t.integer  "footer_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "producttype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "code"
    t.string   "title"
    t.integer  "parent_id"
    t.integer  "company_id"
    t.integer  "project_status"
    t.integer  "ref_system"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projectusers", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revisions", force: true do |t|
    t.string   "rev"
    t.integer  "project_status"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "speclines", force: true do |t|
    t.integer  "project_id"
    t.integer  "clause_id"
    t.integer  "clause_line"
    t.integer  "txt1_id",     default: 1
    t.integer  "txt2_id",     default: 1
    t.integer  "txt3_id",     default: 1
    t.integer  "txt4_id",     default: 1
    t.integer  "txt5_id",     default: 1
    t.integer  "txt6_id",     default: 1
    t.integer  "identity_id", default: 1
    t.integer  "perform_id",  default: 1
    t.integer  "linetype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standards", force: true do |t|
    t.string   "ref"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subsections", force: true do |t|
    t.integer  "cawssubsection_id"
    t.integer  "unisubsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subsectionusers", force: true do |t|
    t.integer  "projectuser_id"
    t.integer  "subsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "termcats", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: true do |t|
    t.integer  "termcat_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "txt1s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "txt2s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "txt3s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "txt4s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "txt5s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "txt6s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unissections", force: true do |t|
    t.string   "ref"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unisubsections", force: true do |t|
    t.integer  "ref"
    t.string   "text"
    t.integer  "unisection_id"
    t.integer  "guidepdf_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "surname"
    t.string   "email"
    t.integer  "role"
    t.string   "api_key"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "failed_attempts"
    t.integer  "locked_at"
    t.integer  "number_times_logged_in"
    t.integer  "active"
    t.datetime "last_sign_in"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "valuetypes", force: true do |t|
    t.integer  "unit_id"
    t.integer  "standard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
