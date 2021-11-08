# frozen_string_literal: true

class AppSearchController < ApplicationController
  ALLOWED_FILTERS = [
    "country", 
    "language", 
    "genres",
    "star_rating",
    "is_in_platform",
    "is_explicit",
  ]

  include Graphql::AuthHelper

  skip_before_action :verify_authenticity_token
  skip_before_action :set_current_user
  # skip_around_action :switch_locale
  
  def search
    if group.can_use_api?("query")
      uri = URI(ENV["APP_SEARCH_URL"] + request.path)
      body = JSON.parse(request.body.read)

      if group.subscription_is?("Starter")
        body["filters"] = {
          "all" => [
            {"any" => [{"is_active" => "true"}]}, 
            {"any" => [{"is_rss_working" => "true"}]}, 
            {"any" => [{"episode_count" => {"from" => 1}}]}
          ]
        }
        body["page"] = {"size" => 25, "current" => 1}
      elsif group.subscription_is?("Professional")
        filters = []
        body["filters"]["all"].each do |f1|
          _f2 = {
            "any" => []
          }
          f1["any"].each do |f2|
            f2.each do |key, value|
              if ALLOWED_FILTERS.include?(key)
                _f2["any"] << {
                  key => value
                }
                filters << _f2
              end
            end
          end

          body["filters"] = {
            "all" => [
              {"any" => [{"is_active" => "true"}]}, 
              {"any" => [{"is_rss_working" => "true"}]}, 
              {"any" => [{"episode_count" => {"from" => 1}}]}
            ]
          }

          body["filters"]["all"] += filters

          body["page"] = {
            "size" => [body["page"]["size"], 50].min,
            "current" => [body["page"]["current"], 5].min
          }
        end
      elsif group.subscription_is?("Enterprise")
        
      end

      response = Net::HTTP.post(
        uri, 
        body.to_json, 
        "Authorization" => "Bearer #{ENV['APP_SEARCH_KEY']}",
        "CONTENT-TYPE" => request.headers["CONTENT-TYPE"] || "application/json",
        "CONTENT-LENGTH" => request.headers["CONTENT-LENGTH"] || "",
      )

      if response.kind_of?(Net::HTTPSuccess)
        group.use_api!("query")
      end

      render inline: response.body.html_safe, layout: false
    else
      head 403, content_type: "application/json"
    end
  end

  def query_suggestion
    uri = URI(ENV["APP_SEARCH_URL"] + request.path)

    response = Net::HTTP.post(
      uri, 
      request.body.read, 
      "Authorization" => "Bearer #{ENV['APP_SEARCH_KEY']}",
      "CONTENT-TYPE" => request.headers["CONTENT-TYPE"] || "application/json",
      "CONTENT-LENGTH" => request.headers["CONTENT-LENGTH"] || "",
    )

    render inline: response.body.html_safe, layout: false
  end

  def click
    uri = URI(ENV["APP_SEARCH_URL"] + request.path)

    response = Net::HTTP.post(
      uri, 
      request.body.read, 
      "Authorization" => "Bearer #{ENV['APP_SEARCH_KEY']}",
      "CONTENT-TYPE" => request.headers["CONTENT-TYPE"] || "application/json",
      "CONTENT-LENGTH" => request.headers["CONTENT-LENGTH"] || "",
    )

    render inline: response.body.html_safe, layout: false
  end

  private
  def group
    group_id = request.headers["X-Acl-Group-Id"]
    group = ::Group.accessible_by(current_ability).find_by(id: group_id)

    if group.nil?
      raise ActiveRecord::RecordNotFound,
        I18n.t('errors.messages.resource_not_found', resource: ::Group.model_name.human)
    end
    group
  end

  def current_ability
    Ability.new(context[:current_user])
  end
end
