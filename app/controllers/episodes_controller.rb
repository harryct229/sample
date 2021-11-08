class EpisodesController < ApplicationController
  def image
    image_url = episode.image_url
    
    if image_url.present?
      if !BlacklistedDomain.exists?(domain: Utils.get_domain(image_url))
        redirect_to image_url, status: 301
        return
      end
    end

    url = Rails.application.routes.url_helpers.rails_blob_url(settings.podcast_default_image)
    redirect_to url, status: 301
  end

  private
  def settings
    @settings ||= GlobalSetting.instance
  end

  def episode
    @episode ||= Crawler::Episode.find(params[:id])
  end
end
