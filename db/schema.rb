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
    t.index ["enabled"], name: "adium_messages_enabled_idx"
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
    t.index ["date"], name: "android_calls_date_idx"
  end

  create_table "android_mmses", id: :integer, default: -> { "nextval('android_mms_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.index ["enabled"], name: "android_mmses_enabled_idx"
    t.index ["xml_sha256"], name: "android_mmses_xml_sha256_idx"
  end

  create_table "android_smses", id: :integer, default: -> { "nextval('smses_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.boolean "enabled"
    t.index ["date"], name: "android_smses_date_idx"
    t.index ["enabled"], name: "android_smses_enabled_idx"
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

  create_table "colloquy_messages", id: :integer, default: -> { "nextval('untitled_table_id_seq2'::regclass)" }, force: :cascade do |t|
    t.text "message_id"
    t.integer "timestamp"
    t.text "from"
    t.text "to"
    t.text "room"
    t.text "message"
    t.text "real_sender"
    t.text "real_receiver"
    t.boolean "enabled", default: true
    t.index ["enabled"], name: "colloquy_messages_enabled_idx"
    t.index ["timestamp"], name: "colloquy_messages_timestamp_idx"
    t.unique_constraint ["message_id"], name: "colloquy_messages_message_id_key"
  end

  create_table "date_summaries", id: :integer, default: -> { "nextval('dates_id_seq'::regclass)" }, force: :cascade do |t|
    t.date "date"
    t.text "event_type"
    t.integer "count"
    t.timestamptz "indexed_at"
    t.index ["date", "event_type"], name: "dates_date_type_idx", unique: true
    t.index ["date"], name: "dates_date_idx"
  end

  create_table "discord_channels", id: :serial, force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.text "discord_type"
    t.text "category_id"
    t.text "category"
    t.text "name"
    t.text "topic"
    t.bigint "guild_id"
    t.text "guild_name"
    t.text "guild_icon_url"

    t.unique_constraint ["channel_id"], name: "discord_channels_discord_id_key"
  end

  create_table "discord_messages", id: :serial, force: :cascade do |t|
    t.text "discord_type"
    t.timestamptz "timestamp"
    t.timestamptz "timestamp_edited"
    t.timestamptz "call_ended_timestamp"
    t.boolean "is_pinned"
    t.text "content"
    t.text "attachments"
    t.text "embeds"
    t.text "stickers"
    t.text "reactions"
    t.text "mentions"
    t.text "inline_emojis"
    t.text "discord_channel_id"
    t.bigint "discord_id", null: false
    t.bigint "author_id", null: false
    t.index ["timestamp"], name: "discord_messages_timestamp_idx"
    t.unique_constraint ["discord_id"], name: "discord_messages_discord_id_key"
  end

  create_table "discord_users", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "discriminator"
    t.text "nickname"
    t.boolean "is_bot"
    t.text "roles"
    t.text "avatarURL"
    t.text "color"
    t.bigint "author_id", null: false

    t.unique_constraint ["author_id"], name: "discord_users_author_id_key"
  end

  create_table "email_messages", id: :integer, default: -> { "nextval('emails_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.index ["timestamp"], name: "email_messages_timestamp_idx"
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
    t.unique_constraint ["thread_path"], name: "facebook_rooms_thread_path_key"
  end

  create_table "fitbit_measurements", id: :serial, force: :cascade do |t|
    t.integer "log_id"
    t.text "source"
    t.decimal "bmi"
    t.decimal "weight"
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
    t.index ["created_date"], name: "google_chat_messages_created_date_idx"
    t.index ["enabled"], name: "google_chat_messages_enabled_idx"
    t.index ["room"], name: "google_chat_messages_room_idx"
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
    t.index ["enabled"], name: "google_talk_messages_enabled_idx"
    t.index ["timestamp"], name: "google_talk_messages_timestamp_idx"
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
    t.index ["conversation_id"], name: "hangouts_events_conversation_id_idx"
    t.index ["enabled"], name: "hangouts_events_enabled_idx"
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

  create_table "historical_weather_readings", id: :integer, default: -> { "nextval('historical_weather_id_seq'::regclass)" }, force: :cascade do |t|
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

  create_table "iphone_calls", id: :serial, force: :cascade do |t|
    t.integer "Z_ENT"
    t.integer "Z_OPT"
    t.integer "ZANSWERED"
    t.integer "ZCALL_CATEGORY"
    t.integer "ZCALLTYPE"
    t.integer "ZDISCONNECTED_CAUSE"
    t.integer "ZFACE_TIME_DATA"
    t.integer "ZHANDLE_TYPE"
    t.integer "ZNUMBER_AVAILABILITY"
    t.integer "ZORIGINATED"
    t.integer "ZREAD"
    t.decimal "ZDURATION"
    t.text "ZDEVICE_ID"
    t.text "ZISO_COUNTRY_CODE"
    t.text "ZLOCATION"
    t.text "ZNAME"
    t.text "ZSERVICE_PROVIDER"
    t.text "ZUNIQUE_ID"
    t.text "ZADDRESS"
    t.boolean "enabled", default: true
    t.decimal "ZDATE"
    t.text "contact_name"
  end

  create_table "iphone_smses", id: :serial, force: :cascade do |t|
    t.text "guid"
    t.text "text"
    t.integer "replace"
    t.text "service_center"
    t.integer "handle_id"
    t.text "subject"
    t.text "country"
    t.integer "version"
    t.integer "message_type"
    t.text "service"
    t.text "account"
    t.text "account_guid"
    t.integer "error"
    t.bigint "date"
    t.bigint "date_read"
    t.bigint "date_delivered"
    t.integer "is_delivered"
    t.integer "is_finished"
    t.integer "is_emote"
    t.integer "is_from_me"
    t.integer "is_empty"
    t.integer "is_delayed"
    t.integer "is_auto_reply"
    t.integer "is_prepared"
    t.integer "is_read"
    t.integer "is_system_message"
    t.integer "is_sent"
    t.integer "has_dd_results"
    t.integer "is_service_message"
    t.integer "is_forward"
    t.integer "was_downgraded"
    t.integer "is_archive"
    t.integer "cache_has_attachments"
    t.text "cache_roomnames"
    t.integer "was_data_detected"
    t.integer "was_deduplicated"
    t.integer "is_audio_message"
    t.integer "is_played"
    t.bigint "date_played"
    t.integer "item_type"
    t.integer "other_handle"
    t.text "group_title"
    t.integer "group_action_type"
    t.integer "share_status"
    t.integer "share_direction"
    t.integer "is_expirable"
    t.integer "expire_state"
    t.integer "message_action_type"
    t.integer "message_source"
    t.text "associated_message_guid"
    t.integer "associated_message_type"
    t.text "balloon_bundle_id"
    t.text "payload_data"
    t.text "expressive_send_style_id"
    t.integer "associated_message_range_location"
    t.integer "associated_message_range_length"
    t.integer "time_expressive_send_played"
    t.text "message_summary_info"
    t.integer "ck_sync_state"
    t.text "ck_record_id"
    t.text "ck_record_change_tag"
    t.text "destination_caller_id"
    t.binary "attributed_body"
    t.boolean "enabled", default: true
    t.text "handle"
    t.text "real_sender"
    t.text "real_receiver"
  end

  create_table "locations", id: :integer, default: -> { "nextval('additional_locations_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.index ["enabled"], name: "lounge_logs_enabled_idx"
    t.index ["timestamp"], name: "lounge_logs_timestamp_idx"
  end

  create_table "mamirc_events", id: :integer, default: -> { "nextval('mamirc_logs_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.index ["enabled"], name: "mamirc_events_enabled_idx"
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
    t.index ["event_type"], name: "matrix_events_event_type_idx"
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

  create_table "microsoft_teams_conversations", id: :serial, force: :cascade do |t|
    t.text "conversation_id"
    t.text "display_name"
    t.bigint "version"
    t.text "properties"
    t.text "thread_properties"
  end

  create_table "microsoft_teams_messages", id: :serial, force: :cascade do |t|
    t.bigint "message_id"
    t.text "display_name"
    t.timestamptz "original_arrival_time"
    t.text "message_type"
    t.bigint "version"
    t.text "content"
    t.text "conversation_id"
    t.text "from"
    t.text "properties"
    t.text "amsreferences"
    t.text "real_sender"
    t.boolean "enabled", default: true
    t.index ["enabled"], name: "microsoft_teams_messages_enabled_idx"
    t.index ["original_arrival_time"], name: "microsoft_teams_messages_original_arrival_time_idx"
  end

  create_table "mirc_logs", id: :serial, force: :cascade do |t|
    t.timestamptz "timestamp"
    t.text "room"
    t.text "username"
    t.text "line"
    t.text "real_sender"
    t.boolean "enabled", default: true
    t.text "real_receiver"
    t.index ["enabled"], name: "mirc_logs_enabled_idx"
    t.index ["room"], name: "mirc_logs_room_idx"
    t.index ["timestamp"], name: "mirc_logs_timestamp_idx"
  end

  create_table "n3ds_activity_events", id: :integer, default: -> { "nextval('\"3ds_activity_events_id_seq\"'::regclass)" }, force: :cascade do |t|
    t.text "date"
    t.text "game"
    t.text "play_time"
    t.integer "play_time_minutes"
    t.text "console"
    t.text "notes"
    t.index ["date", "game", "console"], name: "n3ds_activity_events_date_game_console_idx", unique: true
  end

  create_table "n3ds_activity_logs", id: :integer, default: -> { "nextval('\"3ds_activity_logs_id_seq\"'::regclass)" }, force: :cascade do |t|
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

  create_table "netflix_activities", id: :integer, default: -> { "nextval('netflix_activity_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.index ["enabled"], name: "pidgin_messages_enabled_idx"
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
    t.boolean "enabled", default: true
    t.text "real_receiver"
    t.index ["enabled"], name: "skype_messages_enabled_idx"
    t.index ["real_receiver"], name: "skype_messages_real_receiver_idx"
    t.index ["real_sender"], name: "skype_messages_real_sender_idx"
    t.index ["timestamp"], name: "skype_messages_timestamp_idx"
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
    t.index ["date"], name: "voipms_smses_date_idx"
    t.index ["enabled"], name: "voipms_smses_enabled_idx"
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
    t.boolean "enabled"
    t.index ["enabled"], name: "windows_phone_smses_enabled_idx"
    t.index ["timestamp"], name: "windows_phone_smses_timestamp_idx"
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
    t.index ["enabled"], name: "xchat_logs_enabled_idx"
    t.index ["timestamp"], name: "xchat_logs_timestamp_idx"
  end
end
