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

ActiveRecord::Schema.define(version: 2021_05_29_150820) do

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

  create_table "blocked_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "cur_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cur_id"], name: "index_blocked_users_on_cur_id"
    t.index ["user_id"], name: "index_blocked_users_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.boolean "private", default: false
    t.string "passcode"
    t.boolean "direct", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "direct_rooms", force: :cascade do |t|
    t.bigint "first_user_id"
    t.bigint "second_user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_room_id"], name: "index_direct_rooms_on_chat_room_id"
    t.index ["first_user_id"], name: "index_direct_rooms_on_first_user_id"
    t.index ["second_user_id"], name: "index_direct_rooms_on_second_user_id"
  end

  create_table "duels", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.boolean "confirmed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_duels_on_receiver_id"
    t.index ["sender_id"], name: "index_duels_on_sender_id"
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
    t.string "name"
    t.text "background", default: "/assets/game_back.gif"
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.string "winner", default: "No one"
    t.string "loser", default: "No one"
    t.boolean "is_finished", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "long_paddles", default: false
    t.string "name_player1"
    t.string "name_player2"
    t.string "gametype", default: "casual"
    t.boolean "extra_speed", default: false
    t.bigint "tournament_id"
    t.index ["player1_id"], name: "index_games_on_player1_id"
    t.index ["player2_id"], name: "index_games_on_player2_id"
  end

  create_table "guild_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "guild_id"
    t.integer "user_role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "guild_wars", force: :cascade do |t|
    t.string "status", default: "pending"
    t.bigint "sender_guild_id"
    t.bigint "recipient_guild_id"
    t.string "war_time_begin"
    t.integer "war_time_duration"
    t.integer "battle_begin"
    t.integer "battle_end"
    t.integer "sender_victoies", default: 0
    t.integer "recipient_victories", default: 0
    t.integer "max_ignored_invites"
    t.integer "max_time_of_ignoring_battle"
    t.boolean "add_ones"
    t.boolean "casual_enabled"
    t.boolean "ladder_enabled"
    t.boolean "tournament_enabled"
    t.boolean "is_delay_war"
    t.integer "bank_points", default: 50
    t.integer "duration", default: 2
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

  create_table "pairs", force: :cascade do |t|
    t.bigint "player1_id"
    t.bigint "player2_id"
    t.integer "round"
    t.bigint "game_id"
    t.bigint "tournament_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_pairs_on_game_id"
    t.index ["player1_id"], name: "index_pairs_on_player1_id"
    t.index ["player2_id"], name: "index_pairs_on_player2_id"
    t.index ["tournament_id"], name: "index_pairs_on_tournament_id"
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

  create_table "tournament_members", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "tournament_id"
    t.integer "player_wins"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_tournament_members_on_player_id"
    t.index ["tournament_id"], name: "index_tournament_members_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.integer "count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.boolean "is_ingame", default: false
    t.boolean "is_queueing", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "blocked_users", "users", column: "cur_id"
  add_foreign_key "direct_rooms", "users", column: "first_user_id"
  add_foreign_key "direct_rooms", "users", column: "second_user_id"
  add_foreign_key "duels", "users", column: "receiver_id"
  add_foreign_key "duels", "users", column: "sender_id"
  add_foreign_key "games", "users", column: "player1_id"
  add_foreign_key "games", "users", column: "player2_id"
  add_foreign_key "guild_wars", "guilds", column: "recipient_guild_id"
  add_foreign_key "guild_wars", "guilds", column: "sender_guild_id"
  add_foreign_key "tournament_members", "users", column: "player_id"
end
