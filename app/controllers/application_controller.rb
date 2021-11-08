# frozen_string_literal: true

# Base controlller for application
class ApplicationController < ActionController::Base
  include HttpAuth
  # include LocaleWrapper
  
  skip_before_action :track_ahoy_visit
  before_action :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js   { render 'errors/unauthorized', status: 403 }
      format.html { redirect_to '/', alert: exception.message }
      format.json { render json: { errors: { permission: [exception.message] } }, status: 403 }
    end
  end

  protected

  def current_superadmin
    return nil if current_user.nil?
    # return nil unless current_user.superadmin?

    current_user
  end

  private
  def set_current_user
    User.current_user = current_user if current_user
  end

  def after_sign_in_path_for(resource)
    # if resource.superadmin?
      rails_admin_url
    # else
    #   root_url
    # end
  end
end
