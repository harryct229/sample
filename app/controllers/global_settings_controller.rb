class GlobalSettingsController < ApplicationController
  def logo
    url = Rails.application.routes.url_helpers.rails_blob_url(settings.logo)
    redirect_to url, status: 301
  end

  def podcast_default_image
    url = Rails.application.routes.url_helpers.rails_blob_url(settings.podcast_default_image)
    redirect_to url, status: 301
  end

  def icon
    if size
      url = Rails.application.routes.url_helpers.rails_blob_url(settings.icon.variant(resize_and_pad: size))
    else
      url = Rails.application.routes.url_helpers.rails_blob_url(settings.icon)
    end
    redirect_to url, status: 301
  end

  private
  def settings
    @settings ||= GlobalSetting.instance
  end

  def size
    params[:size]
  end
end
