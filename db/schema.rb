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

ActiveRecord::Schema[7.2].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adium_messages", id: :serial, force: :cascade do |t|
    t.text "sender"
    t.text "receiver"
    t.text "message"
    t.integer "timestamp"
    t.text "real_sender"
    t.text "real_receiver"
    t.boolean "enabled", default: true
    t.index ["timestamp"], name: "adium_messages_timestamp_idx"
  end

  create_table "android_calls", id: :serial, force: :cascade do |t|
    t.text "number"
    t.integer "duration"
    t.bigint "date"
    t.integer "call_type"
    t.integer "presentation"
    t.text "subscription_id"
    t.text "post_dial_digits"
    t.text "subscription_component_name"
    t.text "readable_date"
    t.text "contact_name"
  end

  create_table "android_mmses", id: :serial, force: :cascade do |t|
    t.text "xml"
    t.text "xml_sha256"
    t.text "address"
    t.text "sms_type"
    t.text "body"
    t.text "readable_date"
    t.text "contact_name"
    t.bigint "date"
    t.boolean "enabled"
    t.index ["date"], name: "android_mmses_date_idx"
    t.index ["xml_sha256"], name: "android_mmses_xml_sha256_idx"
  end

  create_table "android_smses", id: :serial, force: :cascade do |t|
    t.text "protocol"
    t.text "address"
    t.bigint "date"
    t.text "sms_type"
    t.text "subject"
    t.text "body"
    t.text "toa"
    t.text "sc_toa"
    t.integer "read"
    t.integer "status"
    t.integer "locked"
    t.bigint "date_sent"
    t.integer "sub_id"
    t.text "readable_date"
    t.text "contact_name"
    t.text "service_center"
    t.index ["date"], name: "android_smses_date_idx"
  end

  create_table "bikeshare_trips", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.text "start_station"
    t.integer "start_time"
    t.text "end_station"
    t.integer "end_time"
    t.integer "duration"
    t.boolean "parsed", default: false
  end

  create_table "calendar_events", id: :serial, force: :cascade do |t|
    t.bigint "start_time"
    t.bigint "end_time"
    t.text "ics"
    t.integer "unpacker"
    t.text "calendar"
    t.text "uid"
    t.text "summary"
    t.timestamptz "scanned_at"
    t.bigint "duration"
    t.text "sha512"
    t.boolean "all_day"
    t.index ["sha512"], name: "calendar_events_sha512_idx"
  end

  create_table "colloquy_messages", id: :serial, force: :cascade do |t|
    t.text "message_id"
    t.integer "timestamp"
    t.text "from"
    t.text "to"
    t.text "room"
    t.text "message"
    t.text "real_sender"
    t.text "real_receiver"
    t.boolean "enabled", default: true
    t.index ["timestamp"], name: "colloquy_messages_timestamp_idx"
    t.unique_constraint ["message_id"], name: "colloquy_messages_message_id_key"
  end

  create_table "date_summaries", id: :serial, force: :cascade do |t|
    t.date "date"
    t.text "event_type"
    t.integer "count"
    t.index ["date", "event_type"], name: "dates_date_type_idx", unique: true
    t.index ["date"], name: "dates_date_idx"
  end

  create_table "email_messages", id: :serial, force: :cascade do |t|
    t.text "account"
    t.timestamptz "timestamp"
    t.text "subject"
    t.text "from"
    t.text "reply_to"
    t.text "to"
    t.text "cc"
    t.text "bcc"
    t.text "in_reply_to"
    t.text "message_id"
    t.text "folder"
    t.binary "body"
  end

  create_table "facebook_messages", id: :serial, force: :cascade do |t|
    t.text "room_id", null: false
    t.text "sender_name"
    t.bigint "timestamp"
    t.text "content"
    t.text "message_type"
    t.index ["room_id"], name: "facebook_messages_room_id_idx"
    t.index ["timestamp"], name: "facebook_messages_timestamp_idx"
  end

  create_table "facebook_rooms", id: :serial, force: :cascade do |t|
    t.text "room_id"
    t.text "title"
    t.text "participants"
    t.text "thread_type"
    t.text "thread_path"
    t.text "real_name"
    t.text "uid"
    t.text "new_room_id"

    t.unique_constraint ["new_room_id"], name: "facebook_rooms_new_room_id_key"
  end

  create_table "fitbit_measurements", id: :serial, force: :cascade do |t|
    t.integer "log_id"
    t.text "source"
    t.decimal "bmi"
    t.integer "weight"
    t.decimal "fat"
  end

  create_table "forum_posts", id: :serial, force: :cascade do |t|
    t.text "site"
    t.integer "timestamp"
    t.text "permalink"
    t.text "thread_title"
    t.text "text"

    t.unique_constraint ["permalink"], name: "forum_posts_permalink_key"
  end

  create_table "github_commits", id: :serial, force: :cascade do |t|
    t.text "sha"
    t.text "node_id"
    t.text "commit"
    t.text "url"
    t.text "html_url"
    t.text "comments_url"
    t.text "author"
    t.text "committer"
    t.text "parents"
    t.text "repo"
    t.integer "timestamp"
  end

  create_table "google_chat_messages", id: :serial, force: :cascade do |t|
    t.text "creator"
    t.text "text"
    t.text "annotations"
    t.text "topic_id"
    t.text "real_sender"
    t.boolean "enabled"
    t.text "room"
    t.integer "created_date"

    t.unique_constraint ["topic_id"], name: "google_chat_messages_topic_id_key"
  end

  create_table "google_talk_messages", id: :serial, force: :cascade do |t|
    t.text "from"
    t.timestamptz "timestamp"
    t.text "message"
    t.text "to"
    t.text "real_sender"
    t.text "real_receiver"
    t.boolean "enabled"
    t.text "room"
  end

  create_table "hangouts_conversations", id: :serial, force: :cascade do |t|
    t.text "conversation_id"
    t.text "conversation_type"
    t.text "self_conversation_state"
    t.text "read_state"
    t.boolean "has_active_hangout"
    t.text "otr_status"
    t.text "otr_toggle"
    t.text "current_participant"
    t.text "participant_data"
    t.boolean "fork_on_external_invite"
    t.text "network_type"
    t.text "force_history_state"
    t.text "group_link_sharing_status"
  end

  create_table "hangouts_events", id: :serial, force: :cascade do |t|
    t.text "conversation_id"
    t.text "sender_id"
    t.text "self_event_state"
    t.text "chat_message"
    t.text "event_id"
    t.text "event_otr"
    t.text "delivery_medium"
    t.text "event_type"
    t.text "event_version"
    t.bigint "timestamp"
    t.boolean "advances_sort_timestamp"
    t.text "real_name"
    t.boolean "enabled", default: true
    t.index ["timestamp"], name: "hangouts_events_timestamp_idx"
  end

  create_table "hindsight_files", id: :serial, force: :cascade do |t|
    t.text "path"
    t.text "extension"
    t.timestamptz "created_at"
    t.timestamptz "modified_at"
    t.timestamptz "scanned_at"

    t.unique_constraint ["path"], name: "hindsight_files_path_key"
  end

  create_table "historical_weather_readings", id: :serial, force: :cascade do |t|
    t.decimal "wdir"
    t.decimal "temp"
    t.decimal "maxt"
    t.decimal "visibility"
    t.decimal "wspd"
    t.bigint "timestamp"
    t.decimal "solarenergy"
    t.decimal "heatindex"
    t.decimal "cloudcover"
    t.decimal "mint"
    t.decimal "precip"
    t.decimal "solarradiation"
    t.text "weathertype"
    t.decimal "snowdepth"
    t.decimal "sealevelpressure"
    t.decimal "snow"
    t.decimal "dew"
    t.decimal "humidity"
    t.decimal "precipcover"
    t.decimal "wgust"
    t.text "conditions"
    t.decimal "windchill"
    t.text "info"
    t.decimal "latitude"
    t.decimal "longitude"
    t.text "location"
    t.index ["timestamp"], name: "historical_weather_readings_timestamp_idx"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.date "date"
    t.text "name"
    t.text "tz"
    t.decimal "latitude"
    t.decimal "longitude"
    t.text "country_code"
    t.boolean "scraped_weather", default: false
    t.index ["date", "name"], name: "locations_date_name_idx", unique: true
  end

  create_table "lounge_logs", id: :serial, force: :cascade do |t|
    t.timestamptz "timestamp"
    t.text "room"
    t.text "username"
    t.text "line"
    t.boolean "enabled", default: true
    t.text "real_sender"
    t.text "real_receiver"
    t.index ["timestamp"], name: "lounge_logs_timestamp_idx"
  end

  create_table "mamirc_events", id: :serial, force: :cascade do |t|
    t.integer "connection_id"
    t.integer "sequence"
    t.bigint "timestamp"
    t.integer "event_type"
    t.text "data"
    t.text "username"
    t.text "room"
    t.text "real_sender"
    t.text "real_receiver"
    t.boolean "enabled"
    t.index ["timestamp"], name: "mamirc_events_timestamp_idx"
  end

  create_table "matrix_events", id: :serial, force: :cascade do |t|
    t.text "event_id"
    t.text "content"
    t.bigint "origin_server_ts"
    t.text "room_id"
    t.text "sender"
    t.text "state_key"
    t.text "event_type"
    t.text "unsigned"
    t.text "plaintext"
    t.index ["event_id"], name: "matrix_events_event_id_idx"
    t.index ["origin_server_ts"], name: "matrix_events_origin_server_ts_idx"
    t.index ["room_id"], name: "matrix_events_room_id_idx"
    t.index ["sender"], name: "matrix_events_sender_idx"
    t.unique_constraint ["event_id"], name: "matrix_events_event_id_key"
  end

  create_table "matrix_rooms", id: :serial, force: :cascade do |t|
    t.text "account"
    t.text "room_id"
    t.text "participants"
    t.boolean "enabled", default: true
    t.timestamptz "last_scraped"
    t.text "name"
    t.text "last_starting_token"
    t.timestamptz "last_message"
    t.boolean "scraping_enabled", default: true
  end

  create_table "mirc_logs", id: :serial, force: :cascade do |t|
    t.timestamptz "timestamp"
    t.text "room"
    t.text "username"
    t.text "line"
    t.text "real_sender"
  end

  create_table "n3ds_activity_events", id: :serial, force: :cascade do |t|
    t.text "date"
    t.text "game"
    t.text "play_time"
    t.integer "play_time_minutes"
    t.text "console"
    t.text "notes"
    t.index ["date", "game", "console"], name: "n3ds_activity_events_date_game_console_idx", unique: true
  end

  create_table "n3ds_activity_logs", id: :serial, force: :cascade do |t|
    t.text "console"
    t.text "game"
    t.text "play_time"
    t.integer "play_time_minutes"
    t.integer "times_played"
    t.text "average_play_time"
    t.date "first_played"
    t.date "last_played"
    t.integer "average_play_time_minutes"
  end

  create_table "netflix_activities", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "videoTitle"
    t.integer "movieID"
    t.text "country"
    t.integer "bookmark"
    t.integer "duration"
    t.bigint "date"
    t.integer "deviceType"
    t.text "dateStr"
    t.integer "index"
    t.text "topNodeId"
    t.text "rating"
    t.integer "series"
    t.text "seriesTitle"
    t.text "seasonDescriptor"
    t.text "episodeTitle"
  end

  create_table "nintendo_switch_online_summaries", id: :serial, force: :cascade do |t|
    t.text "device_id"
    t.date "date", null: false
    t.text "result"
    t.integer "playing_time"
    t.integer "exceeded_time"
    t.integer "disabled_time"
    t.integer "misc_time"
    t.text "important_infos"
    t.text "notices"
    t.text "observations"
    t.text "played_apps"
    t.text "anonymous_player"
    t.text "device_players"
    t.integer "time_zone_utc_offset_seconds"
    t.integer "last_played_at"
    t.integer "created_at"
    t.integer "updated_at"

    t.unique_constraint ["date"], name: "nintendo_switch_online_summaries_date_key"
  end

  create_table "ongoing_events", id: :serial, force: :cascade do |t|
    t.text "name"
    t.date "start_date"
    t.date "end_date"
    t.text "icon"
    t.text "details"
    t.text "category"
    t.text "notes"
  end

  create_table "photo_albums", id: :serial, force: :cascade do |t|
    t.text "name"
    t.integer "start_time"
    t.integer "end_time"
    t.boolean "enabled"
    t.boolean "deep_parsed"
    t.text "folder_name"
    t.boolean "ignore_date_errors"
    t.text "notes"
    t.boolean "event_created"
    t.boolean "has_tz_offset"
    t.integer "object_count"
    t.timestamptz "last_validated_at"
    t.boolean "has_validation_errors"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.text "path"
    t.text "coordinates"
    t.text "sha512"
    t.timestamptz "scanned_at"
    t.integer "timestamp"
    t.index ["path"], name: "photos_path_idx"
    t.index ["timestamp"], name: "photos_timestamp_idx"
    t.unique_constraint ["path"], name: "photos_path_key"
  end

  create_table "pidgin_messages", id: :serial, force: :cascade do |t|
    t.text "service"
    t.text "account"
    t.text "sender"
    t.text "receiver"
    t.text "real_sender"
    t.text "real_receiver"
    t.text "message"
    t.integer "timestamp"
    t.boolean "enabled", default: true
    t.index ["timestamp"], name: "pidgin_messages_timestamp_idx"
  end

  create_table "presto_trips", id: :serial, force: :cascade do |t|
    t.text "timestamp"
    t.text "transit_agency"
    t.text "location"
    t.text "kind"
    t.text "service_class"
    t.text "discount"
    t.text "amount"
    t.text "balance"
    t.boolean "parsed", default: false
  end

  create_table "skype_messages", id: :serial, force: :cascade do |t|
    t.integer "is_permanent"
    t.integer "convo_id"
    t.text "chatname"
    t.text "author"
    t.text "from_dispname"
    t.integer "author_was_live"
    t.text "guid"
    t.text "dialog_partner"
    t.integer "timestamp"
    t.integer "skype_type"
    t.integer "sending_status"
    t.integer "consumption_status"
    t.text "edited_by"
    t.integer "edited_timestamp"
    t.integer "param_key"
    t.integer "param_value"
    t.text "body_xml"
    t.text "identities"
    t.text "reason"
    t.integer "leavereason"
    t.integer "participant_count"
    t.integer "error_code"
    t.integer "chatmsg_type"
    t.integer "chatmsg_status"
    t.integer "body_is_rawxml"
    t.integer "oldoptions"
    t.integer "newoptions"
    t.integer "newrole"
    t.bigint "pk_id"
    t.bigint "crc"
    t.bigint "remote_id"
    t.text "call_guid"
    t.text "extprop_contact_review_date"
    t.integer "extprop_contact_received_stamp"
    t.integer "extprop_contact_reviewed"
    t.integer "skype_id"
    t.integer "option_bits"
    t.bigint "server_id"
    t.bigint "annotation_version"
    t.bigint "timestamp__ms"
    t.text "language"
    t.text "bots_settings"
    t.text "reaction_thread"
    t.integer "content_flags"
    t.integer "extprop_chatmsg_ft_index_timestamp"
    t.integer "extprop_chatmsg_is_pending"
    t.text "real_sender"
    t.text "room_name"

    t.unique_constraint ["guid"], name: "skype_messages_guid_key"
  end

  create_table "starbucks_transactions", id: :serial, force: :cascade do |t|
    t.text "history_id"
    t.text "history_type"
    t.text "transaction_type"
    t.timestamptz "date"
    t.text "earn_rate_display"
    t.text "receipt_number"
    t.text "svc_id"
    t.text "check_id"
    t.text "total_amount"
    t.text "history_overview"
    t.text "tip_info"
    t.text "payload"
  end

  create_table "steam_game_achievements", id: :serial, force: :cascade do |t|
    t.text "steamID"
    t.integer "appid"
    t.text "apiname"
    t.boolean "achieved"
    t.integer "unlocktime"
    t.text "name"
    t.text "description"
    t.boolean "parsed"
  end

  create_table "steam_games", id: :serial, force: :cascade do |t|
    t.integer "appid"
    t.text "name"
    t.integer "playtime_forever"
    t.text "img_icon_url"
    t.boolean "has_community_visible_stats"
    t.integer "playtime_windows_forever"
    t.text "playtime_mac_forever"
    t.text "playtime_linux_forever"
    t.integer "rtime_last_played"
    t.boolean "has_leaderboards"
    t.text "content_descriptorids"
    t.integer "playtime_2weeks"
  end

  create_table "torrents", id: :serial, force: :cascade do |t|
    t.text "filename"
    t.timestamptz "timestamp"
    t.text "readable_name"
    t.boolean "parsed", default: false
    t.boolean "watched"
    t.text "description"
  end

  create_table "voipms_smses", id: :serial, force: :cascade do |t|
    t.integer "voipms_id"
    t.timestamptz "date"
    t.integer "sms_type"
    t.text "did"
    t.text "contact"
    t.text "message"
    t.boolean "enabled"
    t.text "real_name"
  end

  create_table "wii_playtimes", id: :serial, force: :cascade do |t|
    t.text "game"
    t.date "date"
    t.integer "playtime"
  end

  create_table "windows_phone_smses", id: :serial, force: :cascade do |t|
    t.text "xml"
    t.text "body"
    t.text "phone_number"
    t.boolean "is_sent"
    t.text "timestamp_text"
    t.integer "timestamp"
    t.text "real_name"
  end

  create_table "wunderlist_lists", id: :serial, force: :cascade do |t|
    t.integer "wunderlist_id"
    t.text "title"
    t.text "owner_type"
    t.integer "owner_id"
    t.text "list_type"
    t.boolean "public"
    t.integer "revision"
    t.timestamptz "created_at"
    t.text "wl_type"
  end

  create_table "wunderlist_tasks", id: :serial, force: :cascade do |t|
    t.bigint "wunderlist_id"
    t.timestamptz "created_at"
    t.integer "created_by_id"
    t.boolean "completed"
    t.timestamptz "completed_at"
    t.integer "completed_by_id"
    t.boolean "starred"
    t.integer "list_id"
    t.integer "revision"
    t.text "title"
    t.text "wl_type"
  end

  create_table "xchat_logs", id: :serial, force: :cascade do |t|
    t.timestamptz "timestamp"
    t.text "username"
    t.text "line"
    t.text "room"
    t.text "real_sender"
    t.text "real_receiver"
    t.boolean "enabled", default: true
  end
end
