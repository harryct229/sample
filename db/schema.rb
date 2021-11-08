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

ActiveRecord::Schema.define(version: 2021_10_10_163040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.string "country_code"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "api_usages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "subscription_id", null: false
    t.integer "query_quota"
    t.integer "email_quota"
    t.integer "used_query_quota"
    t.integer "used_email_quota"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subscription_id"], name: "index_api_usages_on_subscription_id"
  end

  create_table "blacklisted_domains", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["domain"], name: "index_blacklisted_domains_on_domain", unique: true
  end

  create_table "brand_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "parent_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_category_id"], name: "index_brand_categories_on_parent_category_id"
  end

  create_table "brand_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaign_podcast_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "podcast_category_id", null: false
    t.uuid "campaign_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_campaign_podcast_categories_on_campaign_id"
    t.index ["podcast_category_id"], name: "index_campaign_podcast_categories_on_podcast_category_id"
  end

  create_table "campaigns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "created_by_id", null: false
    t.uuid "group_id", null: false
    t.uuid "language_id", null: false
    t.uuid "country_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal "budget", precision: 8, scale: 2
    t.integer "objective"
    t.integer "creative_option"
    t.string "name"
    t.string "website"
    t.integer "state"
    t.hstore "budget_distributions", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_campaigns_on_country_id"
    t.index ["created_by_id"], name: "index_campaigns_on_created_by_id"
    t.index ["group_id"], name: "index_campaigns_on_group_id"
    t.index ["language_id"], name: "index_campaigns_on_language_id"
  end

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "group_id", null: false
    t.uuid "podcast_id"
    t.uuid "created_by_id"
    t.integer "master_podcast_id", null: false
    t.string "conversation_sid"
    t.binary "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_conversations_on_created_by_id"
    t.index ["group_id"], name: "index_conversations_on_group_id"
    t.index ["master_podcast_id"], name: "index_conversations_on_master_podcast_id"
    t.index ["podcast_id"], name: "index_conversations_on_podcast_id"
  end

  create_table "countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "global_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "singleton_guard"
    t.string "name"
    t.string "tracking_domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["singleton_guard"], name: "index_global_settings_on_singleton_guard", unique: true
  end

  create_table "group_brand_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "group_id", null: false
    t.uuid "brand_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_category_id"], name: "index_group_brand_categories_on_brand_category_id"
    t.index ["group_id"], name: "index_group_brand_categories_on_group_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "tier_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company_name"
    t.string "website"
    t.uuid "parent_group_id"
    t.uuid "country_id"
    t.string "stripe_customer_id"
    t.boolean "is_trial_done", default: false
    t.uuid "created_by_id"
    t.uuid "updated_by_id"
    t.index ["country_id"], name: "index_groups_on_country_id"
    t.index ["created_by_id"], name: "index_groups_on_created_by_id"
    t.index ["parent_group_id"], name: "index_groups_on_parent_group_id"
    t.index ["tier_id"], name: "index_groups_on_tier_id"
    t.index ["updated_by_id"], name: "index_groups_on_updated_by_id"
  end

  create_table "languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "podcast_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "parent_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_category_id"], name: "index_podcast_categories_on_parent_category_id"
  end

  create_table "podcast_countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "podcast_id", null: false
    t.uuid "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_podcast_countries_on_country_id"
    t.index ["podcast_id"], name: "index_podcast_countries_on_podcast_id"
  end

  create_table "podcast_languages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "podcast_id", null: false
    t.uuid "language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["language_id"], name: "index_podcast_languages_on_language_id"
    t.index ["podcast_id"], name: "index_podcast_languages_on_podcast_id"
  end

  create_table "podcast_podcast_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "podcast_id", null: false
    t.uuid "podcast_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_category_id"], name: "index_podcast_podcast_categories_on_podcast_category_id"
    t.index ["podcast_id"], name: "index_podcast_podcast_categories_on_podcast_id"
  end

  create_table "podcast_social_networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "podcast_id", null: false
    t.uuid "social_network_id", null: false
    t.string "social_id"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_id"], name: "index_podcast_social_networks_on_podcast_id"
    t.index ["social_network_id"], name: "index_podcast_social_networks_on_social_network_id"
  end

  create_table "podcasts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "master_podcast_id"
    t.integer "temporary_podcast_id"
    t.string "website"
    t.text "name"
    t.text "artist_name"
    t.string "feed_url"
    t.string "additional_feed_url"
    t.string "image_url"
    t.string "owner_email"
    t.date "start_date"
    t.integer "listener_count", default: 0
    t.integer "reach_count", default: 0
    t.integer "subscriber_count", default: 0
    t.integer "episode_count", default: 0
    t.integer "frequency", default: 0
    t.boolean "is_explicit", default: false
    t.integer "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.text "publishing_days", default: [], array: true
    t.string "hosting"
    t.datetime "locked_at"
    t.boolean "is_hosting_connected", default: false, null: false
    t.boolean "is_spotify_connected", default: false, null: false
    t.string "typeform_response_id"
    t.index ["master_podcast_id"], name: "index_podcasts_on_master_podcast_id"
    t.index ["temporary_podcast_id"], name: "index_podcasts_on_temporary_podcast_id"
    t.index ["user_id"], name: "index_podcasts_on_user_id"
  end

  create_table "publishers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rollups", force: :cascade do |t|
    t.string "name", null: false
    t.string "interval", null: false
    t.datetime "time", null: false
    t.jsonb "dimensions", default: {}, null: false
    t.float "value"
    t.index ["name", "interval", "time", "dimensions"], name: "index_rollups_on_name_and_interval_and_time_and_dimensions", unique: true
  end

  create_table "social_networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "spotify_episode_analytics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "episode_id"
    t.string "claimed_spotify_link"
    t.json "gender_distribution"
    t.json "country_distribution"
    t.json "age_distribution"
    t.integer "starts"
    t.integer "listeners"
    t.integer "streams"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["episode_id"], name: "index_spotify_episode_analytics_on_episode_id"
  end

  create_table "spotify_podcast_analytics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "podcast_id", null: false
    t.string "claimed_spotify_link"
    t.json "gender_distribution"
    t.json "country_distribution"
    t.json "age_distribution"
    t.integer "starts"
    t.integer "listeners"
    t.integer "streams"
    t.integer "followers"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["podcast_id"], name: "index_spotify_podcast_analytics_on_podcast_id"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "external_id", default: "", null: false
    t.uuid "group_id", null: false
    t.text "status", null: false
    t.boolean "cancel_at_period_end", default: false, null: false
    t.datetime "current_period_start", null: false
    t.datetime "current_period_end", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_subscriptions_on_group_id"
  end

  create_table "tiers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "group_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "user_social_networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "social_network_id", null: false
    t.string "profile_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["social_network_id"], name: "index_user_social_networks_on_social_network_id"
    t.index ["user_id"], name: "index_user_social_networks_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "refresh_token"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.uuid "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "type"
    t.uuid "publisher_id"
    t.uuid "brand_type_id"
    t.integer "purpose", default: 1, null: false
    t.integer "state"
    t.string "prefix_token"
    t.string "phone_number"
    t.integer "notifications", default: [], null: false, array: true
    t.datetime "password_changed_at"
    t.index ["brand_type_id"], name: "index_users_on_brand_type_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["prefix_token"], name: "index_users_on_prefix_token", unique: true
    t.index ["publisher_id"], name: "index_users_on_publisher_id"
    t.index ["refresh_token"], name: "index_users_on_refresh_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_usages", "subscriptions"
  add_foreign_key "brand_categories", "brand_categories", column: "parent_category_id"
  add_foreign_key "campaign_podcast_categories", "campaigns"
  add_foreign_key "campaign_podcast_categories", "podcast_categories"
  add_foreign_key "campaigns", "countries"
  add_foreign_key "campaigns", "groups"
  add_foreign_key "campaigns", "languages"
  add_foreign_key "campaigns", "users", column: "created_by_id"
  add_foreign_key "conversations", "groups"
  add_foreign_key "conversations", "podcasts"
  add_foreign_key "conversations", "users", column: "created_by_id"
  add_foreign_key "group_brand_categories", "brand_categories"
  add_foreign_key "group_brand_categories", "groups"
  add_foreign_key "groups", "countries"
  add_foreign_key "groups", "groups", column: "parent_group_id"
  add_foreign_key "groups", "tiers"
  add_foreign_key "groups", "users", column: "created_by_id"
  add_foreign_key "groups", "users", column: "updated_by_id"
  add_foreign_key "podcast_categories", "podcast_categories", column: "parent_category_id"
  add_foreign_key "podcast_countries", "countries"
  add_foreign_key "podcast_countries", "podcasts"
  add_foreign_key "podcast_languages", "languages"
  add_foreign_key "podcast_languages", "podcasts"
  add_foreign_key "podcast_podcast_categories", "podcast_categories"
  add_foreign_key "podcast_podcast_categories", "podcasts"
  add_foreign_key "podcast_social_networks", "podcasts"
  add_foreign_key "podcast_social_networks", "social_networks"
  add_foreign_key "podcasts", "users"
  add_foreign_key "spotify_podcast_analytics", "podcasts"
  add_foreign_key "subscriptions", "groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_social_networks", "social_networks"
  add_foreign_key "user_social_networks", "users"
  add_foreign_key "users", "brand_types"
  add_foreign_key "users", "publishers"
end
