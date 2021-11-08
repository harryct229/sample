# Temporary Patch - Waiting for ahoy_matey 3.2.1
module Ahoy
  class GeocodeV2Job < ActiveJob::Base
    queue_as { Ahoy.job_queue }

    def perform(visit_token, ip)
      location =
        begin
          Geocoder.search(ip).first
        rescue => e
          Ahoy.log "Geocode error: #{e.class.name}: #{e.message}"
          nil
        end

      if location && location.country.present?
        data = {
          country: location.country,
          country_code: location.try(:country_code).presence,
          region: location.try(:state).presence,
          city: location.try(:city).presence,
          postal_code: location.try(:postal_code).presence,
          latitude: location.try(:latitude).presence,
          longitude: location.try(:longitude).presence
        }

        Ahoy::Tracker.new(visit_token: visit_token).geocode(data)
      end
    end
  end
end

class TrackingsController < ApplicationController
  # skip_before_action :track_ahoy_visit

  def show
    prefix_token = params[:prefix_token]
    redirect_url = params[:redirect_url]

    begin
      podcaster = Podcaster.find_by(prefix_token: prefix_token)

      logger.info("Prefix Token: #{prefix_token}")
      logger.info("Redirect URL: #{redirect_url}")

      if podcaster
        podcast, episode = podcaster.find_podcast_and_episode(redirect_url)

        if episode
          event = Ahoy::Event.where_event("Listen Episode", episode_id: episode.id)

          visit = ahoy.track "Listen Episode", {
            podcast_id: podcast.id,
            episode_id: episode.id
          }
        else
          logger.warn("Episode not found!")
        end
      else
        logger.warn("Podcaster not found!")
      end
    rescue Exception => e
      logger.error(e)
    end

    redirect_to CGI.unescape(redirect_url), status: 303
  end
end
