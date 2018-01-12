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

ActiveRecord::Schema.define(version: 20160327215510) do

  create_table "alterations", force: true do |t|
    t.integer  "specline_id"
    t.integer  "project_id"
    t.integer  "clause_id"
    t.integer  "txt3_id"
    t.integer  "txt4_id"
    t.integer  "txt5_id"
    t.integer  "txt6_id"
    t.integer  "identity_id"
    t.integer  "perform_id"
    t.integer  "linetype_id"
    t.string   "event"
    t.integer  "clause_add_delete", default: 1, null: false
    t.integer  "revision_id"
    t.integer  "print_change",      default: 1, null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alterations", ["revision_id", "project_id", "event", "clause_id"], name: "CLAUSE", using: :btree
  add_index "alterations", ["revision_id", "project_id"], name: "PROJECT", using: :btree

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

  add_index "charcs", ["instance_id"], name: "INSTANCE", using: :btree
  add_index "charcs", ["perform_id"], name: "PERFORM", using: :btree

  create_table "clauseguides", force: true do |t|
    t.integer  "clause_id"
    t.integer  "guidenote_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clauseproducts", force: true do |t|
    t.integer  "clause_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clauseproducts", ["clause_id"], name: "CLAUSE", using: :btree
  add_index "clauseproducts", ["product_id"], name: "PRODUCT", using: :btree

  create_table "clauserefs", force: true do |t|
    t.integer  "clausetype_id"
    t.integer  "clause_no"
    t.integer  "subclause"
    t.integer  "subsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clauserefs", ["clausetype_id"], name: "CLAUSETYPE", using: :btree
  add_index "clauserefs", ["subsection_id", "clausetype_id"], name: "SUBECTION_CLAUSETYPE", using: :btree
  add_index "clauserefs", ["subsection_id"], name: "SUBSECTION", using: :btree

  create_table "clauses", force: true do |t|
    t.integer  "clauseref_id"
    t.integer  "clausetitle_id"
    t.integer  "guidenote_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clauses", ["clauseref_id"], name: "CLAUSEREF", using: :btree
  add_index "clauses", ["project_id"], name: "PROJECT", using: :btree

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

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "www"
    t.string   "reg_address"
    t.string   "reg_number"
    t.string   "reg_name"
    t.string   "reg_location"
    t.integer  "read_term"
    t.integer  "category"
    t.string   "logo"
    t.integer  "no_licence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["name"], name: "COMPANY_NAME", using: :btree

  create_table "descripts", force: true do |t|
    t.integer  "identity_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "descripts", ["identity_id"], name: "IDENTITY", using: :btree
  add_index "descripts", ["product_id"], name: "PRODUCT", using: :btree

  create_table "guidenotes", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guidepdfs", force: true do |t|
    t.integer  "title"
    t.integer  "guide"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", force: true do |t|
    t.string   "item"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "identkey_id"
    t.integer  "identvalue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["identkey_id"], name: "KEY", using: :btree
  add_index "identities", ["identvalue_id"], name: "VALUE", using: :btree

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

  add_index "identvalues", ["company_id"], name: "COMPANY", using: :btree
  add_index "identvalues", ["identtxt_id"], name: "TEXT", using: :btree

  create_table "instances", force: true do |t|
    t.integer  "product_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instances", ["product_id"], name: "PRODUCT", using: :btree

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
    t.integer  "performkey_id"
    t.integer  "performvalue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "performs", ["performkey_id"], name: "PERFORMKEY", using: :btree

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
    t.string   "font_style"
    t.string   "font_size"
    t.string   "structure"
    t.string   "prelim"
    t.string   "page_number"
    t.string   "client_detail"
    t.string   "client_logo"
    t.string   "project_detail"
    t.string   "project_image"
    t.string   "company_detail"
    t.string   "header_project"
    t.string   "header_client"
    t.string   "header_document"
    t.string   "header_logo"
    t.string   "footer_detail"
    t.string   "footer_author"
    t.string   "footer_date"
    t.string   "section_cover"
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
    t.string   "project_image"
    t.string   "client_logo"
    t.string   "client_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "refsystem_id"
    t.string   "printsetting_id"
  end

  add_index "projects", ["company_id"], name: "COMPANY", using: :btree

  create_table "projectusers", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projectusers", ["project_id"], name: "PROJECT", using: :btree
  add_index "projectusers", ["user_id"], name: "USER", using: :btree

  create_table "refsystems", force: true do |t|
    t.integer  "name"
    t.integer  "subsection"
    t.integer  "section"
    t.integer  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revisions", force: true do |t|
    t.string   "rev"
    t.string   "project_status"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "revisions", ["project_id"], name: "PROJECT", using: :btree

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

  add_index "speclines", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "speclines", ["project_id", "clause_id"], name: "SPEC", using: :btree

  create_table "standardkeys", force: true do |t|
    t.integer  "standard_id"
    t.integer  "performkey_id"
    t.string   "type"
    t.string   "verification"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standards", force: true do |t|
    t.string   "ref"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "year"
    t.string   "status"
    t.string   "type"
  end

  create_table "subsections", force: true do |t|
    t.integer  "cawssubsection_id"
    t.integer  "unisubsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subsections", ["cawssubsection_id"], name: "CAWS", using: :btree
  add_index "subsections", ["unisubsection_id"], name: "UNI", using: :btree

  create_table "subsectionusers", force: true do |t|
    t.integer  "projectuser_id"
    t.integer  "subsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subsectionusers", ["projectuser_id"], name: "PROJECT", using: :btree
  add_index "subsectionusers", ["subsection_id"], name: "SUBSECTION", using: :btree

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

  add_index "txt3s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt3s", ["text"], name: "text_UNIQUE", unique: true, using: :btree

  create_table "txt4s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "txt4s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt4s", ["text"], name: "text_UNIQUE", unique: true, using: :btree

  create_table "txt5s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "txt5s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt5s", ["text"], name: "text_UNIQUE", unique: true, using: :btree

  create_table "txt6s", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "txt6s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt6s", ["text"], name: "text_UNIQUE", unique: true, using: :btree

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
    t.integer  "role"
    t.string   "ip"
    t.string   "api_key"
    t.string   "state"
    t.integer  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "valuetypes", force: true do |t|
    t.integer  "unit_id"
    t.integer  "standard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
