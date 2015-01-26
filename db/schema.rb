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

  create_table "abouts", force: true do |t|
    t.text    "text"
    t.string  "image", limit: 45
    t.integer "order", limit: 1
  end

  create_table "accounts", force: true do |t|
    t.integer "company_id", default: 0, null: false
    t.integer "no_licence", default: 0, null: false
  end

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

  add_index "alterations", ["revision_id", "project_id", "event", "clause_id"], name: "CLAUSE", using: :btree

  create_table "cawssections", force: true do |t|
    t.string "ref",  limit: 1, null: false
    t.string "text",           null: false
  end

  create_table "cawssubsections", force: true do |t|
    t.integer "ref",            limit: 1,   null: false
    t.string  "text",           limit: 200, null: false
    t.integer "cawssection_id", limit: 1,   null: false
    t.string  "guidepdf_id",    limit: 50
  end

  add_index "cawssubsections", ["cawssection_id"], name: "SECTIONID", using: :btree
  add_index "cawssubsections", ["text"], name: "text_UNIQUE", unique: true, using: :btree

  create_table "charcs", force: true do |t|
    t.integer   "instance_id"
    t.integer   "perform_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "charcs", ["instance_id"], name: "instance", using: :btree
  add_index "charcs", ["perform_id"], name: "perform", using: :btree

  create_table "clauseproducts", force: true do |t|
    t.integer "product_id"
    t.integer "clause_id",  limit: 2
  end

  add_index "clauseproducts", ["clause_id"], name: "clause", using: :btree
  add_index "clauseproducts", ["product_id"], name: "product", using: :btree

  create_table "clauserefs", force: true do |t|
    t.integer "subsection_id", limit: 2, default: 0, null: false
    t.integer "clausetype_id", limit: 2, default: 0, null: false
    t.integer "clause_no",     limit: 2, default: 0, null: false
    t.integer "subclause",     limit: 2, default: 0, null: false
  end

  add_index "clauserefs", ["subsection_id", "clausetype_id"], name: "subsection_id", using: :btree

  create_table "clauses", force: true do |t|
    t.integer "clauseref_id",                         null: false
    t.integer "clausetitle_id", limit: 2,             null: false
    t.integer "guidenote_id"
    t.integer "project_id",               default: 1, null: false
  end

  create_table "clausetitles", force: true do |t|
    t.string "text", limit: 250, null: false
  end

  create_table "clausetypes", force: true do |t|
    t.string "text", limit: 50, null: false
  end

  create_table "clients", force: true do |t|
    t.string  "name",        limit: 1
    t.integer "project_id"
    t.string  "client_logo", limit: 1
  end

  create_table "comments", force: true do |t|
    t.integer  "post_id",                null: false
    t.text     "text",                   null: false
    t.text     "author",                 null: false
    t.text     "email",                  null: false
    t.integer  "checked",    default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "companies", ["name"], name: "company_name", unique: true, using: :btree

  create_table "descripts", force: true do |t|
    t.integer "identity_id"
    t.integer "product_id"
  end

  add_index "descripts", ["identity_id"], name: "identity", using: :btree
  add_index "descripts", ["product_id"], name: "product", using: :btree

  create_table "faqs", force: true do |t|
    t.string "question"
    t.string "answer",   limit: 500
  end

  create_table "featurecontents", force: true do |t|
    t.integer "feature_id", limit: 1
    t.integer "order",      limit: 1
    t.string  "title",      limit: 45
    t.text    "text"
    t.string  "image",      limit: 45
  end

  create_table "features", force: true do |t|
    t.string "title", limit: 50
    t.text   "text"
    t.string "image"
  end

  create_table "guidedownloads", force: true do |t|
    t.integer  "guidepdf_id",            null: false
    t.integer  "user_id"
    t.string   "ipaddress",   limit: 50
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "guidenotes", force: true do |t|
    t.text "text"
  end

  create_table "guidepdfs", force: true do |t|
    t.string    "title",            limit: 100, null: false
    t.string    "pdf_file_name",                null: false
    t.string    "pdf_content_type",             null: false
    t.integer   "pdf_file_size",                null: false
    t.timestamp "pdf_updated_at",               null: false
  end

  create_table "guides", force: true do |t|
    t.text "text"
  end

  create_table "helps", force: true do |t|
    t.string "title", limit: 100
    t.string "video", limit: 50
  end

  add_index "helps", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "homes", force: true do |t|
    t.string "strapline",     limit: 250, null: false
    t.text   "intro_text",                null: false
    t.string "option_1_text", limit: 250, null: false
    t.string "option_2_text",             null: false
    t.string "option_3_text", limit: 250, null: false
    t.string "image",         limit: 20
  end

  create_table "identities", force: true do |t|
    t.integer "identkey_id"
    t.integer "identvalue_id"
  end

  add_index "identities", ["identkey_id"], name: "key", using: :btree
  add_index "identities", ["identvalue_id"], name: "value", using: :btree

  create_table "identkeys", force: true do |t|
    t.string "text", limit: 45
  end

  create_table "identtxts", force: true do |t|
    t.string "text", limit: 45
  end

  create_table "identvalues", force: true do |t|
    t.integer "company_id"
    t.integer "identtxt_id"
  end

  add_index "identvalues", ["company_id"], name: "compmany", using: :btree
  add_index "identvalues", ["identtxt_id"], name: "text", using: :btree

  create_table "instances", force: true do |t|
    t.integer   "product_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "code",       limit: 45
  end

  add_index "instances", ["product_id"], name: "product", using: :btree

  create_table "licences", force: true do |t|
    t.integer  "user_id"
    t.integer  "failed_attempts",                   default: 0
    t.integer  "locked_at"
    t.integer  "number_times_logged_in",            default: 0
    t.integer  "active_licence",                    default: 0
    t.datetime "last_sign_in"
    t.string   "ip",                     limit: 50
  end

  create_table "lineclausetypes", force: true do |t|
    t.integer "linetype_id",   limit: 1, default: 0
    t.integer "clausetype_id", limit: 1, default: 0
  end

  create_table "linetypes", force: true do |t|
    t.string  "ref",         limit: 50, null: false
    t.string  "description", limit: 50, null: false
    t.string  "example",     limit: 50, null: false
    t.boolean "txt1",                   null: false
    t.boolean "txt2",                   null: false
    t.boolean "txt3",                   null: false
    t.boolean "txt4",                   null: false
    t.boolean "txt5",                   null: false
    t.boolean "txt6",                   null: false
    t.string  "identity",    limit: 45, null: false
    t.string  "perform",     limit: 45, null: false
  end

  create_table "performkeys", force: true do |t|
    t.string "text", limit: 45
  end

  create_table "performs", force: true do |t|
    t.integer   "performkey_id",   limit: 2
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "performvalue_id"
  end

  add_index "performs", ["performkey_id"], name: "performkey", using: :btree

  create_table "performtxts", force: true do |t|
    t.string "text", limit: 45
  end

  create_table "performvalues", force: true do |t|
    t.integer "performtxt_id", limit: 3
    t.integer "valuetype_id",  limit: 2
  end

  create_table "planfeatures", force: true do |t|
    t.integer "priceplan_id", limit: 1
    t.string  "text"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "topic",      limit: 50
  end

  create_table "priceplans", force: true do |t|
    t.string  "name",    limit: 50
    t.string  "plan",    limit: 50
    t.integer "sign_up", limit: 1
  end

  create_table "prints", force: true do |t|
    t.integer   "project_id"
    t.integer   "revision_id", limit: 1
    t.integer   "user_id"
    t.string    "print",       limit: 1
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

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
  end

  create_table "productgroups", force: true do |t|
    t.integer   "clause_id"
    t.string    "txt4_id",     limit: 50
    t.string    "ref",         limit: 50
    t.string    "name",        limit: 50
    t.integer   "supplier_id",            null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "productimports", force: true do |t|
    t.integer   "user_id"
    t.string    "csv_file_name"
    t.string    "csv_content_type"
    t.integer   "csv_file_size"
    t.timestamp "csv_updated_at"
    t.string    "action",           limit: 10
    t.timestamp "date_completed"
    t.timestamp "created_at"
  end

  create_table "products", force: true do |t|
    t.integer   "producttype_id", limit: 2
    t.timestamp "created_at"
    t.timestamp "update_at"
  end

  create_table "producttypes", force: true do |t|
    t.string "text", limit: 45
  end

  create_table "projects", force: true do |t|
    t.string    "code",           limit: 45,              null: false
    t.string    "title",          limit: 200,             null: false
    t.integer   "parent_id",                              null: false
    t.integer   "company_id",                             null: false
    t.integer   "project_status", limit: 1,   default: 0, null: false
    t.integer   "ref_system",     limit: 1,   default: 0
    t.string    "project_image"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "client_logo"
    t.string    "client_name"
  end

  add_index "projects", ["company_id"], name: "COMPANY", using: :btree

  create_table "projectusers", force: true do |t|
    t.integer   "user_id",    null: false
    t.integer   "project_id", null: false
    t.integer   "role",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "ranges", force: true do |t|
    t.integer   "clause_id"
    t.string    "txt4_id",     limit: 50
    t.string    "ref",         limit: 50
    t.string    "name",        limit: 50
    t.integer   "supplier_id",            null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "references", force: true do |t|
    t.string "text"
    t.string "author"
    t.string "company_name"
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

  create_table "sessions", force: true do |t|
    t.string    "session_id", null: false
    t.text      "data"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

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

  create_table "sponsors", force: true do |t|
    t.integer "supplier_id"
    t.integer "subsection_id"
    t.string  "www"
  end

  create_table "sponsorvisits", force: true do |t|
    t.integer   "sponsor_id",            null: false
    t.integer   "user_id"
    t.string    "ipaddress",  limit: 20
    t.timestamp "created_at",            null: false
  end

  create_table "standards", force: true do |t|
    t.string "ref",   limit: 20
    t.string "title", limit: 150
  end

  create_table "subsections", force: true do |t|
    t.integer   "cawssubsection_id", limit: 2
    t.integer   "unisubsection_id",  limit: 2
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "subsectionusers", force: true do |t|
    t.integer   "projectuser_id"
    t.integer   "subsection_id",  limit: 1
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "suppliers", force: true do |t|
    t.string   "company_name",       null: false
    t.string   "www",                null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "templates", force: true do |t|
    t.string    "csv_file_name",    limit: 50, null: false
    t.string    "csv_content_type", limit: 50, null: false
    t.integer   "csv_file_size",               null: false
    t.timestamp "csv_updated_at",              null: false
  end

  create_table "termcats", force: true do |t|
    t.text "text"
  end

  create_table "terms", force: true do |t|
    t.integer "termcat_id", limit: 1,   default: 0,   null: false
    t.string  "text",       limit: 600, default: "0"
  end

  create_table "txt1s", force: true do |t|
    t.string   "text",       limit: 2, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "txt1s", ["id"], name: "id_UNIQUE", unique: true, using: :btree
  add_index "txt1s", ["text"], name: "text_UNIQUE", unique: true, using: :btree

  create_table "txt2s", force: true do |t|
    t.string    "text",       limit: 2, null: false
    t.timestamp "created_at",           null: false
    t.timestamp "updated_at",           null: false
  end

  add_index "txt2s", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "txt3s", force: true do |t|
    t.string    "text",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt3s", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "txt4s", force: true do |t|
    t.text      "text",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt4s", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "txt5s", force: true do |t|
    t.text      "text",       null: false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "txt5s", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "txt6s", force: true do |t|
    t.string    "text",       limit: 100, null: false
    t.timestamp "created_at",             null: false
    t.timestamp "updated_at",             null: false
  end

  add_index "txt6s", ["id"], name: "id_UNIQUE", unique: true, using: :btree

  create_table "units", force: true do |t|
    t.string "text", limit: 10
  end

  create_table "users", force: true do |t|
    t.string    "email"
    t.integer   "company_id"
    t.string    "first_name",             limit: 50
    t.string    "surname",                limit: 50
    t.integer   "role",                   limit: 1
    t.string    "password_hash"
    t.string    "password_salt"
    t.string    "password_reset_token"
    t.timestamp "password_reset_sent_at"
    t.integer   "failed_attempts",        limit: 1
    t.integer   "locked_at",              limit: 1
    t.integer   "number_times_logged_in", limit: 2
    t.integer   "active",                 limit: 1
    t.timestamp "last_sign_in"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "ip",                     limit: 45
    t.string    "api_key",                limit: 1
    t.string    "encrypted_password",                default: "", null: false
    t.string    "reset_password_token"
    t.datetime  "reset_password_sent_at"
    t.datetime  "remember_created_at"
    t.integer   "sign_in_count",                     default: 0,  null: false
    t.datetime  "current_sign_in_at"
    t.datetime  "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "unlock_token"
  end

  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "valuetypes", force: true do |t|
    t.integer "unit_id",     limit: 2
    t.integer "standard_id", limit: 2
  end

  create_table "webcontent", force: true do |t|
    t.string  "page",    limit: 15,  null: false
    t.string  "subpage", limit: 45
    t.integer "column",  limit: 1
    t.string  "title",   limit: 45
    t.string  "text",    limit: 500
    t.string  "image",   limit: 15
    t.string  "type",    limit: 45,  null: false
  end

end
