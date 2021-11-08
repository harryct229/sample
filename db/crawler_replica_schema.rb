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

ActiveRecord::Schema.define(version: 0) do

  create_table "auth_group", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.index ["name"], name: "name", unique: true
  end

  create_table "auth_group_permissions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "permission_id", null: false
    t.index ["group_id", "permission_id"], name: "auth_group_permissions_group_id_permission_id_0cd325b0_uniq", unique: true
    t.index ["permission_id"], name: "auth_group_permissio_permission_id_84c5c92e_fk_auth_perm"
  end

  create_table "auth_permission", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "content_type_id", null: false
    t.string "codename", limit: 100, null: false
    t.index ["content_type_id", "codename"], name: "auth_permission_content_type_id_codename_01ab375a_uniq", unique: true
  end

  create_table "auth_user", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "password", limit: 128, null: false
    t.datetime "last_login", precision: 6
    t.boolean "is_superuser", null: false
    t.string "username", limit: 150, null: false
    t.string "first_name", limit: 150, null: false
    t.string "last_name", limit: 150, null: false
    t.string "email", limit: 254, null: false
    t.boolean "is_staff", null: false
    t.boolean "is_active", null: false
    t.datetime "date_joined", precision: 6, null: false
    t.index ["username"], name: "username", unique: true
  end

  create_table "auth_user_groups", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "auth_user_groups_group_id_97559544_fk_auth_group_id"
    t.index ["user_id", "group_id"], name: "auth_user_groups_user_id_group_id_94350c0c_uniq", unique: true
  end

  create_table "auth_user_user_permissions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "permission_id", null: false
    t.index ["permission_id"], name: "auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm"
    t.index ["user_id", "permission_id"], name: "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq", unique: true
  end

  create_table "consolidated_records", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_count", null: false
    t.integer "episode_count", null: false
    t.text "podcast_count_by_category", size: :long, null: false
    t.text "podcast_count_by_episode_count", size: :long, null: false
    t.text "podcast_count_by_language", size: :long, null: false
    t.text "podcast_count_by_country", size: :long, null: false
    t.text "podcast_count_by_hosting", size: :long, null: false
    t.text "podcast_count_by_prefix", size: :long, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "episode_count_by_created_at", size: :long, null: false
    t.text "podcast_count_by_created_at", size: :long, null: false
    t.text "episode_count_by_duration", size: :long, null: false
    t.text "podcast_count_by_category_with_ghost", size: :long
    t.text "podcast_count_by_country_with_ghost", size: :long
    t.text "podcast_count_by_episode_count_with_ghost", size: :long
    t.text "podcast_count_by_hosting_with_ghost", size: :long
    t.text "podcast_count_by_language_with_ghost", size: :long
    t.text "podcast_count_by_prefix_with_ghost", size: :long
    t.text "podcast_count_with_ghost", size: :long
    t.text "episode_count_by_star_rating", size: :long, null: false
    t.text "episode_count_by_star_rating_with_ghost", size: :long
    t.text "podcast_count_by_star_rating", size: :long, null: false
    t.text "podcast_count_by_star_rating_with_ghost", size: :long
    t.text "podcasts_by_ranking_with_ghost", size: :long
    t.string "country", limit: 50
    t.index ["country"], name: "consolidate_country_b9cd74_idx"
  end

  create_table "django_admin_log", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "action_time", precision: 6, null: false
    t.text "object_id", size: :long
    t.string "object_repr", limit: 200, null: false
    t.integer "action_flag", limit: 2, null: false, unsigned: true
    t.text "change_message", size: :long, null: false
    t.integer "content_type_id"
    t.integer "user_id", null: false
    t.index ["content_type_id"], name: "django_admin_log_content_type_id_c4bce8eb_fk_django_co"
    t.index ["user_id"], name: "django_admin_log_user_id_c564eba6_fk_auth_user_id"
    t.check_constraint "`action_flag` >= 0", name: "action_flag"
  end

  create_table "django_celery_beat_clockedschedule", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "clocked_time", precision: 6, null: false
  end

  create_table "django_celery_beat_crontabschedule", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "minute", limit: 240, null: false
    t.string "hour", limit: 96, null: false
    t.string "day_of_week", limit: 64, null: false
    t.string "day_of_month", limit: 124, null: false
    t.string "month_of_year", limit: 64, null: false
    t.string "timezone", limit: 63, null: false
  end

  create_table "django_celery_beat_intervalschedule", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "every", null: false
    t.string "period", limit: 24, null: false
  end

  create_table "django_celery_beat_periodictask", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.string "task", limit: 200, null: false
    t.text "args", size: :long, null: false
    t.text "kwargs", size: :long, null: false
    t.string "queue", limit: 200
    t.string "exchange", limit: 200
    t.string "routing_key", limit: 200
    t.datetime "expires", precision: 6
    t.boolean "enabled", null: false
    t.datetime "last_run_at", precision: 6
    t.integer "total_run_count", null: false, unsigned: true
    t.datetime "date_changed", precision: 6, null: false
    t.text "description", size: :long, null: false
    t.integer "crontab_id"
    t.integer "interval_id"
    t.integer "solar_id"
    t.boolean "one_off", null: false
    t.datetime "start_time", precision: 6
    t.integer "priority", unsigned: true
    t.text "headers", size: :long, null: false
    t.integer "clocked_id"
    t.integer "expire_seconds", unsigned: true
    t.index ["clocked_id"], name: "django_celery_beat_p_clocked_id_47a69f82_fk_django_ce"
    t.index ["crontab_id"], name: "django_celery_beat_p_crontab_id_d3cba168_fk_django_ce"
    t.index ["interval_id"], name: "django_celery_beat_p_interval_id_a8ca27da_fk_django_ce"
    t.index ["name"], name: "name", unique: true
    t.index ["solar_id"], name: "django_celery_beat_p_solar_id_a87ce72c_fk_django_ce"
    t.check_constraint "`expire_seconds` >= 0", name: "expire_seconds"
    t.check_constraint "`priority` >= 0", name: "priority"
    t.check_constraint "`total_run_count` >= 0", name: "total_run_count"
  end

  create_table "django_celery_beat_periodictasks", primary_key: "ident", id: { type: :integer, limit: 2, default: nil }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "last_update", precision: 6, null: false
  end

  create_table "django_celery_beat_solarschedule", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "event", limit: 24, null: false
    t.decimal "latitude", precision: 9, scale: 6, null: false
    t.decimal "longitude", precision: 9, scale: 6, null: false
    t.index ["event", "latitude", "longitude"], name: "django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq", unique: true
  end

  create_table "django_content_type", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "app_label", limit: 100, null: false
    t.string "model", limit: 100, null: false
    t.index ["app_label", "model"], name: "django_content_type_app_label_model_76bd3d3b_uniq", unique: true
  end

  create_table "django_migrations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "app", null: false
    t.string "name", null: false
    t.datetime "applied", precision: 6, null: false
  end

  create_table "django_session", primary_key: "session_key", id: { type: :string, limit: 40 }, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "session_data", size: :long, null: false
    t.datetime "expire_date", precision: 6, null: false
    t.index ["expire_date"], name: "django_session_expire_date_a5c62663"
  end

  create_table "episodes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id", null: false
    t.binary "title", size: :long, null: false
    t.binary "description", size: :long, null: false
    t.text "image_url", size: :long
    t.text "audio_url", size: :long, null: false
    t.datetime "published_at", precision: 6
    t.string "guid", limit: 500, null: false
    t.bigint "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "transcripts", size: :long
    t.string "podcast_type", limit: 50
    t.index ["podcast_id", "guid", "podcast_type"], name: "episodes_podcast_020be2_idx"
    t.index ["podcast_id", "podcast_type"], name: "episodes_podcast_f17a47_idx"
  end

  create_table "master_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.binary "name", size: :long
    t.binary "artist_name", size: :long
    t.binary "description", size: :long
    t.string "owner_email", limit: 1000
    t.text "feed_url", size: :long
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.string "language", limit: 50
    t.string "country", limit: 50
    t.integer "episode_count", null: false
    t.text "genres", size: :long
    t.string "hosting", limit: 1000
    t.string "prefixes", limit: 1000
    t.float "star_rating", limit: 53
    t.integer "rating_count"
    t.float "ranking", limit: 53
    t.string "has_rankings", limit: 500
    t.string "influenced_countries", limit: 1000
    t.text "keywords", size: :long
    t.boolean "is_ghost"
    t.boolean "is_in_platform", null: false
    t.boolean "is_active", null: false
    t.datetime "last_released_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "synced_at", precision: 6
    t.string "hosting_domain", limit: 1000
    t.string "tracking_analytics", limit: 1000
    t.boolean "is_rss_working"
    t.integer "frequency"
    t.integer "linked_podcast_id"
    t.integer "ranking_listener_offset"
    t.integer "ranking_reach_offset"
    t.index ["is_active", "is_ghost"], name: "master_podc_is_acti_6ccbc2_idx"
    t.index ["is_active", "is_in_platform"], name: "master_podc_is_acti_5f7d0a_idx"
    t.index ["is_active", "is_rss_working"], name: "master_podc_is_acti_dd5699_idx"
    t.index ["is_active"], name: "master_podc_is_acti_84c4e4_idx"
    t.index ["is_ghost"], name: "master_podc_is_ghos_e3ef7f_idx"
    t.index ["updated_at"], name: "master_podc_updated_ea86ac_idx"
  end

  create_table "rankings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.string "apple_podcast_id", limit: 50
    t.integer "period", null: false
    t.string "chart", limit: 50, null: false
    t.string "country", limit: 50, null: false
    t.string "category", limit: 100, null: false
    t.integer "rank", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "chartable_url", limit: 500
    t.binary "name", size: :long
    t.index ["apple_podcast_id"], name: "rankings_apple_p_ce6278_idx"
    t.index ["chart", "country", "category"], name: "rankings_chart_e94295_idx"
    t.index ["chart", "podcast_id"], name: "rankings_chart_eab2c0_idx"
    t.index ["chartable_url"], name: "rankings_chartab_bddcfa_idx"
    t.index ["period", "chart", "country", "category", "podcast_id"], name: "rankings_period_789a7a_idx"
    t.index ["period", "chart", "country", "category"], name: "rankings_period_22c8c0_idx"
    t.index ["period", "chart", "podcast_id"], name: "rankings_period_982dbf_idx"
    t.index ["period", "podcast_id"], name: "rankings_period_85c1ac_idx"
    t.index ["period"], name: "rankings_period_0a7608_idx"
    t.index ["podcast_id"], name: "rankings_podcast_593403_idx"
  end

  create_table "slave_apple_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.string "apple_podcast_id", limit: 50, null: false
    t.string "apple_artist_id", limit: 50
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.string "primary_genre", limit: 50, null: false
    t.string "genres", limit: 1000, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "rating_count"
    t.float "star_rating", limit: 53
    t.string "country", limit: 50, null: false
    t.boolean "is_rss_working"
    t.string "language", limit: 50, null: false
    t.string "raw_language", limit: 50, null: false
    t.string "owner_email", limit: 200
    t.binary "description", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.text "keywords", size: :long
    t.index ["apple_podcast_id"], name: "apple_podcast_id_UNIQUE", unique: true
    t.index ["apple_podcast_id"], name: "slave_apple_apple_p_3b59f8_idx"
    t.index ["apple_podcast_id"], name: "slave_apple_podcasts_apple_podcast_id_01113e77_uniq", unique: true
    t.index ["podcast_id"], name: "slave_apple_podcast_35eef5_idx"
  end

  create_table "slave_castbox_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.integer "castbox_id", null: false
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.integer "comment_count", null: false
    t.integer "play_count", null: false
    t.integer "sub_count", null: false
    t.text "social_ids", size: :long
    t.text "keywords", size: :long
    t.string "website", limit: 500
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country", limit: 50, null: false
    t.string "genres", limit: 1000, null: false
    t.boolean "is_rss_working"
    t.string "language", limit: 50, null: false
    t.string "raw_language", limit: 50, null: false
    t.string "owner_email", limit: 200
    t.binary "description", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.index ["castbox_id"], name: "castbox_id", unique: true
    t.index ["castbox_id"], name: "slave_castb_castbox_d9ffa3_idx"
    t.index ["podcast_id"], name: "slave_castb_podcast_8a9194_idx"
  end

  create_table "slave_matchcasts_imported_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.string "language", limit: 50, null: false
    t.string "country", limit: 50, null: false
    t.boolean "is_explicit", null: false
    t.string "genres", limit: 1000, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "spotify_id", limit: 50
    t.boolean "is_rss_working"
    t.string "raw_language", limit: 50, null: false
    t.string "owner_email", limit: 200
    t.binary "description", size: :long
    t.text "keywords", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.text "updated_fields", size: :long
    t.index ["podcast_id"], name: "slave_match_podcast_1d719d_idx"
    t.index ["spotify_id"], name: "slave_match_spotify_a264ea_idx"
  end

  create_table "slave_matchcasts_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.string "matchcasts_id", limit: 100, null: false
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.string "genres", limit: 1000, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country", limit: 50, null: false
    t.string "language", limit: 50, null: false
    t.text "social_ids", size: :long
    t.string "spotify_id", limit: 50
    t.boolean "is_active", null: false
    t.string "owner_email", limit: 200
    t.binary "description", size: :long
    t.text "keywords", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.boolean "is_rss_working"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.index ["matchcasts_id"], name: "slave_match_matchca_ee67f7_idx"
    t.index ["matchcasts_id"], name: "slave_matchcasts_podcasts_matchcasts_id_fc250420_uniq", unique: true
    t.index ["podcast_id"], name: "slave_match_podcast_acf70a_idx"
    t.index ["spotify_id"], name: "slave_match_spotify_e77ad8_idx"
  end

  create_table "slave_podchaser_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podchaser_id", null: false
    t.string "apple_podcast_id", limit: 50
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.string "genres", limit: 1000, null: false
    t.float "star_rating", limit: 53
    t.integer "rating_count", null: false
    t.integer "review_count", null: false
    t.integer "follower_count", null: false
    t.integer "total_hashtag_count", null: false
    t.text "keywords", size: :long
    t.text "external_ids", size: :long
    t.text "social_links", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "podcast_id"
    t.string "website", limit: 500
    t.string "spotify_id", limit: 50
    t.string "country", limit: 50, null: false
    t.boolean "is_rss_working"
    t.string "language", limit: 50, null: false
    t.string "raw_language", limit: 50, null: false
    t.string "owner_email", limit: 200
    t.binary "description", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.index ["apple_podcast_id"], name: "slave_podch_apple_p_10a174_idx"
    t.index ["podcast_id"], name: "slave_podch_podcast_9e348d_idx"
    t.index ["podchaser_id"], name: "podchaser_id", unique: true
    t.index ["podchaser_id"], name: "slave_podch_podchas_55527d_idx"
    t.index ["spotify_id"], name: "slave_podch_spotify_0b1d90_idx"
  end

  create_table "slave_soundon_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.string "soundon_id", limit: 50, null: false
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.string "import_feed_url", limit: 500
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.string "raw_language", limit: 50, null: false
    t.string "language", limit: 50, null: false
    t.string "country", limit: 50, null: false
    t.string "genres", limit: 1000, null: false
    t.text "social_ids", size: :long
    t.text "keywords", size: :long
    t.boolean "is_rss_working"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "owner_email", limit: 200
    t.binary "description", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.index ["podcast_id"], name: "slave_sound_podcast_fe903f_idx"
    t.index ["soundon_id"], name: "slave_sound_soundon_fe7f3b_idx"
    t.index ["soundon_id"], name: "soundon_id", unique: true
  end

  create_table "slave_spotify_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id"
    t.string "spotify_id", limit: 50, null: false
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country", limit: 50, null: false
    t.boolean "is_rss_working"
    t.string "language", limit: 50, null: false
    t.string "raw_language", limit: 50, null: false
    t.string "genres", limit: 1000, null: false
    t.binary "description", size: :long
    t.text "keywords", size: :long
    t.datetime "synced_at", precision: 6
    t.integer "frequency"
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.boolean "is_ghost"
    t.datetime "last_released_at", precision: 6
    t.string "prefixes", limit: 500
    t.string "tracking_analytics", limit: 500
    t.boolean "is_explicit", null: false
    t.index ["podcast_id"], name: "slave_spoti_podcast_7a97d2_idx"
    t.index ["spotify_id"], name: "slave_spoti_spotify_329f9e_idx"
    t.index ["spotify_id"], name: "slave_spotify_podcasts_spotify_id_54f61f94_uniq", unique: true
  end

  create_table "slave_temporary_podcasts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.binary "name", size: :long, null: false
    t.binary "artist_name", size: :long, null: false
    t.binary "description", size: :long
    t.string "owner_email", limit: 200
    t.string "feed_url", limit: 500
    t.text "image_url", size: :long
    t.boolean "is_explicit", null: false
    t.string "language", limit: 50, null: false
    t.string "country", limit: 50, null: false
    t.string "genres", limit: 1000, null: false
    t.text "keywords", size: :long
    t.string "hosting", limit: 100
    t.string "hosting_domain", limit: 200
    t.string "tracking_analytics", limit: 500
    t.string "prefixes", limit: 500
    t.integer "frequency"
    t.boolean "is_rss_working"
    t.boolean "is_ghost"
    t.boolean "is_active", null: false
    t.datetime "last_released_at", precision: 6
    t.datetime "synced_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "episode_count", null: false
  end

  create_table "social_identifiers", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "podcast_id", null: false
    t.string "platform", limit: 50, null: false
    t.string "name", limit: 200, null: false
    t.text "figures", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_id", "platform", "name"], name: "social_iden_podcast_d033c6_idx"
    t.index ["podcast_id", "platform"], name: "social_iden_podcast_6ab69d_idx"
    t.index ["podcast_id"], name: "social_iden_podcast_71deab_idx"
  end

  create_table "task_states", id: :integer, charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "task_name", limit: 100, null: false
    t.integer "empty_count", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_name"], name: "task_name", unique: true
  end

  add_foreign_key "auth_group_permissions", "auth_group", column: "group_id", name: "auth_group_permissions_group_id_b120cbf9_fk_auth_group_id"
  add_foreign_key "auth_group_permissions", "auth_permission", column: "permission_id", name: "auth_group_permissio_permission_id_84c5c92e_fk_auth_perm"
  add_foreign_key "auth_permission", "django_content_type", column: "content_type_id", name: "auth_permission_content_type_id_2f476e4b_fk_django_co"
  add_foreign_key "auth_user_groups", "auth_group", column: "group_id", name: "auth_user_groups_group_id_97559544_fk_auth_group_id"
  add_foreign_key "auth_user_groups", "auth_user", column: "user_id", name: "auth_user_groups_user_id_6a12ed8b_fk_auth_user_id"
  add_foreign_key "auth_user_user_permissions", "auth_permission", column: "permission_id", name: "auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm"
  add_foreign_key "auth_user_user_permissions", "auth_user", column: "user_id", name: "auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id"
  add_foreign_key "django_admin_log", "auth_user", column: "user_id", name: "django_admin_log_user_id_c564eba6_fk_auth_user_id"
  add_foreign_key "django_admin_log", "django_content_type", column: "content_type_id", name: "django_admin_log_content_type_id_c4bce8eb_fk_django_co"
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_clockedschedule", column: "clocked_id", name: "django_celery_beat_p_clocked_id_47a69f82_fk_django_ce"
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_crontabschedule", column: "crontab_id", name: "django_celery_beat_p_crontab_id_d3cba168_fk_django_ce"
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_intervalschedule", column: "interval_id", name: "django_celery_beat_p_interval_id_a8ca27da_fk_django_ce"
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_solarschedule", column: "solar_id", name: "django_celery_beat_p_solar_id_a87ce72c_fk_django_ce"
end
