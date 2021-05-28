# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_15_122327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banned_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_banned_users_on_chat_room_id"
    t.index ["user_id"], name: "index_banned_users_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.boolean "private", default: false
    t.string "passcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "friend_id"
    t.boolean "confirmed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "game_members", force: :cascade do |t|
    t.bigint "first_player_id"
    t.bigint "second_player_id"
    t.integer "winner", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_player_id"], name: "index_game_members_on_first_player_id"
    t.index ["second_player_id"], name: "index_game_members_on_second_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "status_game", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "background", default: "/assets/game_back.gif"
  end

  create_table "guild_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "guild_id"
    t.integer "user_role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "guild_wars", force: :cascade do |t|
    t.string "status"
    t.bigint "sender_guild_id"
    t.bigint "recipient_guild_id"
    t.integer "war_time_begin"
    t.integer "war_time_end"
    t.integer "battle_begin"
    t.integer "battle_end"
    t.integer "sender_victoies"
    t.integer "recipient_victories"
    t.integer "max_ignored_invites"
    t.integer "max_time_of_ignoring_battle"
    t.boolean "add_ones"
    t.boolean "casual_enabled"
    t.boolean "ladder_enabled"
    t.boolean "tournament_enabled"
    t.boolean "is_delay_war"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipient_guild_id"], name: "index_guild_wars_on_recipient_guild_id"
    t.index ["sender_guild_id"], name: "index_guild_wars_on_sender_guild_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "anagram"
    t.text "description"
    t.integer "rating", default: 1000
    t.text "photo", default: "/assets/standart_guild_avatar.png"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "muted_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_muted_users_on_chat_room_id"
    t.index ["user_id"], name: "index_muted_users_on_user_id"
  end

  create_table "room_members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.integer "member_role", default: 0
    t.boolean "muted", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_room_members_on_chat_room_id"
    t.index ["user_id"], name: "index_room_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nickname"
    t.integer "status", default: 0
    t.string "provider"
    t.string "uid"
    t.boolean "admin", default: false
    t.integer "rating", default: 1000
    t.text "photo", default: "/assets/standart_avatar.png"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "guild_wars", "guilds", column: "recipient_guild_id"
  add_foreign_key "guild_wars", "guilds", column: "sender_guild_id"
end
