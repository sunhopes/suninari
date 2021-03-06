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

ActiveRecord::Schema.define(version: 2021_05_25_054506) do

  create_table "gpathways", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "species"
    t.string "tissue"
    t.string "cell_line"
    t.string "bind_backbone"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pw_category"
    t.string "pw_category_id"
    t.string "species_id"
    t.string "tissue_id"
    t.string "cell_line_id"
    t.string "disease"
    t.string "disease_id"
  end

  create_table "greactions", force: :cascade do |t|
    t.string "rxnid"
    t.string "reactant"
    t.string "enzyme_name"
    t.string "sugar_nt"
    t.string "product"
    t.string "cellular_locate"
    t.integer "gpathway_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reactant_img"
    t.string "product_img"
    t.integer "sugar_id"
    t.string "enzyme_onto_id"
    t.string "sugar_onto_id"
    t.string "cellcomp_onto_id"
    t.index ["gpathway_id"], name: "index_greactions_on_gpathway_id"
    t.index ["sugar_id"], name: "index_greactions_on_sugar_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
