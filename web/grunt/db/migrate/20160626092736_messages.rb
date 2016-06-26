class Messages < ActiveRecord::Migration
  def change
      create_table "message_types", force: true do |t|
        t.string   "subject",    null: false
        t.text     "text",       null: false
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "code",       null: false
      end

      add_index "message_types", ["code"], name: "message_types_code_idx", unique: true, using: :btree

      create_table "messages", force: true do |t|
        t.integer  "camera_id",    null: false
        t.datetime "timestamp",    null: false
        t.integer  "message_type", null: false
        t.boolean  "read",         default: false, null: false
        t.boolean  "resolved",     default: false, null: false
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "extra_text"
        t.binary   "extra_data"
      end

      add_index "messages", ["camera_id"], name: "messages_cameraid_idx", using: :btree
      add_index "messages", ["message_type"], name: "messages_messagetype_idx", using: :btree
      add_index "messages", ["read"], name: "messages_read_idx", using: :btree
  end
end
