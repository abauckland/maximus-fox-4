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

ActiveRecord::Schema.define(version: 20150103132040) do

  create_table "projects", force: true do |t|
    t.string    "code",           limit: 45,              null: false
    t.string    "title",          limit: 200,             null: false
    t.integer   "parent_id",                              null: false
    t.integer   "company_id",                             null: false
    t.integer   "project_status", limit: 1,   default: 0, null: false
    t.integer   "ref_system",     limit: 1,   default: 0
    t.string    "project_image"
    t.string    "client_logo"
    t.string    "client_name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "projects", ["company_id"], name: "COMPANY", using: :btree


  create_table "users", force: true do |t|
    t.string    "email"
    t.integer   "company_id"
    t.string    "first_name",             limit: 50
    t.string    "surname",                limit: 50
    t.integer   "role",                   limit: 1
    t.string    "state"
    t.string    "ip"
    t.string    "api_key"
    t.string    "encrypted_password", default: "", null: false
    t.string    "reset_password_token"
    t.datetime  "reset_password_sent_at"
    t.datetime  "remember_created_at"
    t.integer   "sign_in_count", default: 0,  null: false
    t.datetime  "current_sign_in_at"
    t.datetime  "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.integer  "failed_attempts", default: 0,  null: false
    t.string    "unlock_token"
    t.integer   "locked_at", limit: 1
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree


  create_table "helps", force: true do |t|
    t.string "item"
    t.text "text",                 default: true, null: false
  end


  create_table "revisions", force: true do |t|
    t.string    "rev",            limit: 2
    t.string    "project_status", limit: 15
    t.integer   "project_id",                null: false
    t.integer   "user_id"
    t.date      "date"
    t.timestamp "updated_at"
    t.timestamp "created_at"
  end

  add_index "revisions", ["project_id"], name: "PROJECT", using: :btree


  create_table "speclines", force: true do |t|
    t.integer   "project_id",  limit: 2,             null: false
    t.integer   "clause_id",   limit: 2,             null: false
    t.integer   "clause_line", limit: 1,             null: false
    t.integer   "txt1_id",     limit: 1, default: 1, null: false
    t.integer   "txt2_id",     limit: 1, default: 1, null: false
    t.integer   "txt3_id",     limit: 2, default: 1, null: false
    t.integer   "txt4_id",     limit: 2, default: 1, null: false
    t.integer   "txt5_id",     limit: 2, default: 1, null: false
    t.integer   "txt6_id",     limit: 2, default: 1, null: false
    t.integer   "identity_id", limit: 2, default: 1, null: false
    t.integer   "perform_id",  limit: 2, default: 1, null: false
    t.integer   "linetype_id", limit: 1,             null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "speclines", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "speclines", ["project_id", "clause_id"], name: "SPEC", using: :btree


  create_table "alterations", force: true do |t|
    t.integer   "specline_id",                                 null: false
    t.integer   "project_id",        limit: 2,                 null: false
    t.integer   "clause_id",         limit: 2,                 null: false
    t.integer   "txt3_id",           limit: 2,                 null: false
    t.integer   "txt4_id",           limit: 2,                 null: false
    t.integer   "txt5_id",           limit: 2,                 null: false
    t.integer   "txt6_id",           limit: 2,                 null: false
    t.integer   "identity_id",       limit: 2,                 null: false
    t.integer   "perform_id",        limit: 2,                 null: false
    t.integer   "linetype_id",       limit: 1,                 null: false
    t.string    "event",             limit: 10,                null: false
    t.integer   "clause_add_delete", limit: 2,  default: 1,    null: false
    t.integer   "revision_id",       limit: 2,                 null: false
    t.boolean   "print_change",                 default: true, null: false
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "alterations", ["revision_id", "project_id"], name: "PROJECT", using: :btree
  add_index "alterations", ["revision_id", "project_id", "event", "clause_id"], name: "CLAUSE", using: :btree


  create_table "projectusers", force: true do |t|
    t.integer   "user_id",    null: false
    t.integer   "project_id", null: false
    t.integer   "role",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "projectusers", "user_id", name: "USER", using: :btree
  add_index "projectusers", "project_id", name: "PROJECT", using: :btree


  create_table "subsections", force: true do |t|
    t.integer   "cawssubsection_id", limit: 2
    t.integer   "unisubsection_id",  limit: 2
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "subsections", "cawssubsection_id", name: "CAWS", using: :btree
  add_index "subsections", "unisubsection_id", name: "UNI", using: :btree

  create_table "cawssubsections", force: true do |t|
    t.integer "ref",            limit: 1,   null: false
    t.string  "text",           limit: 200, null: false
    t.integer "cawssection_id", limit: 1,   null: false
    t.string  "guidepdf_id",    limit: 50
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "cawssections", force: true do |t|
    t.string "ref",            null: false
    t.string "text",           null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "subsectionusers", force: true do |t|
    t.integer   "projectuser_id"
    t.integer   "subsection_id",  limit: 1
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "subsectionusers", "projectuser_id", name: "PROJECT", using: :btree
  add_index "subsectionusers", "subsection_id", name: "SUBSECTION", using: :btree


  create_table "unisubsections", force: true do |t|
    t.integer "ref",            limit: 1,   null: false
    t.string  "text",           limit: 200, null: false
    t.integer "unisection_id", limit: 1,   null: false
    t.string  "guidepdf_id",    limit: 50
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "unisections", force: true do |t|
    t.string "ref",            null: false
    t.string "text",           null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "termcats", force: true do |t|
    t.string "text"
  end


  create_table "terms", force: true do |t|
    t.integer "termcat_id"
    t.text  "text"
  end


  create_table "companies", force: true do |t|
    t.string    "name",         limit: 200, null: false
    t.string    "tel",          limit: 20
    t.string    "www"
    t.string    "reg_address"
    t.string    "reg_number"
    t.string    "reg_name"
    t.string    "reg_location"
    t.string    "logo"
    t.integer   "read_term"
    t.integer   "category"
    t.integer   "no_licence",   limit: 1
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "companies", ["name"], name: "company_name", using: :btree


  create_table "linetypes", force: true do |t|
    t.string  "ref",         limit: 50, null: false
    t.string  "description", limit: 50, null: false
    t.string  "example",     limit: 50, null: false
    t.integer "txt1",                   null: false
    t.integer "txt2",                   null: false
    t.integer "txt3",                   null: false
    t.integer "txt4",                   null: false
    t.integer "txt5",                   null: false
    t.integer "txt6",                   null: false
    t.integer "identity",               null: false
    t.integer "perform",                null: false

    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "lineclausetypes", force: true do |t|
    t.integer "linetype_id",   limit: 1, default: 0
    t.integer "clausetype_id", limit: 1, default: 0

    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "clausetypes", force: true do |t|
    t.string "text", limit: 50, null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "clausetitles", force: true do |t|
    t.string "text", limit: 250, null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "txt1s", force: true do |t|
    t.string   "text",       limit: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end


  create_table "txt2s", force: true do |t|
    t.string    "text",       limit: 2, null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "txt3s", force: true do |t|
    t.string    "text",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt3s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt3s", ["text"], name: "text_UNIQUE", unique: true, using: :btree
  

  create_table "txt4s", force: true do |t|
    t.text      "text",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt4s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt4s", ["text"], name: "text_UNIQUE", unique: true, using: :btree
  

  create_table "txt5s", force: true do |t|
    t.text      "text",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt5s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt5s", ["text"], name: "text_UNIQUE", unique: true, using: :btree
  

  create_table "txt6s", force: true do |t|
    t.string    "text", null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt6s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt6s", ["text"], name: "text_UNIQUE", unique: true, using: :btree


  create_table "clauserefs", force: true do |t|
    t.integer "subsection_id", limit: 2, default: 0, null: false
    t.integer "clausetype_id", limit: 2, default: 0, null: false
    t.integer "clause_no",     limit: 2, default: 0, null: false
    t.integer "subclause",     limit: 2, default: 0, null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "clauserefs", ["subsection_id"], name: "SUBSECTION", using: :btree
  add_index "clauserefs", ["clausetype_id"], name: "CLAUSETYPE", using: :btree
  add_index "clauserefs", ["subsection_id", "clausetype_id"], name: "SUBECTION_CLAUSETYPE", using: :btree


  create_table "clauses", force: true do |t|
    t.integer "clauseref_id",                         null: false
    t.integer "clausetitle_id", limit: 2,             null: false
    t.integer "guidenote_id"
    t.integer "project_id",               default: 1, null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "clauses", ["project_id"], name: "PROJECT", using: :btree
  add_index "clauses", ["clauseref_id"], name: "CLAUSEREF", using: :btree


  create_table "guidenotes", force: true do |t|
    t.text "text"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "units", force: true do |t|
    t.string "text", limit: 10
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "performtxts", force: true do |t|
    t.string "text", limit: 45
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "standards", force: true do |t|
    t.string "ref",   limit: 20
    t.string "title", limit: 150
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "valuetypes", force: true do |t|
    t.integer "unit_id",     limit: 2
    t.integer "standard_id", limit: 2
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "performvalues", force: true do |t|
    t.integer "performtxt_id", limit: 3
    t.integer "valuetype_id",  limit: 2
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "performs", force: true do |t|
    t.integer   "performkey_id",   limit: 2
    t.integer   "performvalue_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "performs", "performkey_id", name: "PERFORMKEY", using: :btree


  create_table "charcs", force: true do |t|
    t.integer   "instance_id"
    t.integer   "perform_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "charcs", "instance_id", name: "INSTANCE", using: :btree
  add_index "charcs", "perform_id", name: "PERFORM", using: :btree


  create_table "instances", force: true do |t|
    t.integer   "product_id"
    t.string    "code", limit: 45
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "instances", "product_id", name: "PRODUCT", using: :btree


  create_table "identities", force: true do |t|
    t.integer "identkey_id"
    t.integer "identvalue_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "identities", "identkey_id", name: "KEY", using: :btree
  add_index "identities", "identvalue_id", name: "VALUE", using: :btree


  create_table "identkeys", force: true do |t|
    t.string "text", limit: 45
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "identtxts", force: true do |t|
    t.string "text", limit: 45
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end


  create_table "identvalues", force: true do |t|
    t.integer "company_id"
    t.integer "identtxt_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "identvalues", "company_id", name: "COMPANY", using: :btree
  add_index "identvalues", "identtxt_id", name: "TEXT", using: :btree


  create_table "descripts", force: true do |t|
    t.integer "identity_id"
    t.integer "product_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "descripts", "identity_id", name: "IDENTITY", using: :btree
  add_index "descripts", "product_id", name: "PRODUCT", using: :btree


  create_table "products", force: true do |t|
    t.integer   "producttype_id", limit: 2
    t.timestamp "created_at"
    t.timestamp "update_at"
  end


  create_table "clauseproducts", force: true do |t|
    t.integer "product_id"
    t.integer "clause_id",  limit: 2
    t.timestamp "created_at"
    t.timestamp "update_at"
  end

  add_index "clauseproducts", "clause_id", name: "CLAUSE", using: :btree
  add_index "clauseproducts", "product_id", name: "PRODUCT", using: :btree


  create_table "printsettings", force: true do |t|
    t.integer "project_id"
    t.string  "font_style",      limit: 45
    t.string  "font_size",       limit: 45
    t.string  "structure",       limit: 45
    t.string  "prelim",          limit: 45
    t.string  "page_number",     limit: 45
    t.string  "client_detail",   limit: 45
    t.string  "client_logo",     limit: 45
    t.string  "project_detail",  limit: 45
    t.string  "project_image",   limit: 45
    t.string  "company_detail",  limit: 45
    t.string  "header_project",  limit: 45
    t.string  "header_client",   limit: 45
    t.string  "header_document", limit: 45
    t.string  "header_logo",     limit: 45
    t.string  "footer_detail",   limit: 45
    t.string  "footer_author",   limit: 45
    t.string  "footer_date",     limit: 45
    t.string  "section_cover",   limit: 45
    t.timestamp "created_at"
    t.timestamp "update_at"
  end


  create_table "performkeys", force: true do |t|
    t.string "text", limit: 45
    t.timestamp "created_at"
    t.timestamp "update_at"
  end


  create_table "prints", force: true do |t|
    t.integer   "project_id"
    t.integer   "revision_id", limit: 1
    t.integer   "user_id"
    t.string    "print",       limit: 1
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

end
