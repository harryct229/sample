class ActiveStorage::BaseController < ActionController::Base
  include ActiveStorage::SetCurrent

  skip_before_action :track_ahoy_visit

  protect_from_forgery with: :exception

  self.etag_with_template_digest = false

  private
  def stream(blob)
    blob.download do |chunk|
      response.stream.write chunk
    end
  ensure
    response.stream.close
  end
end
