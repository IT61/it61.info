require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.is_fresh?
      redirect_to sign_up_complete_path
    else
      Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      throw exception unless Rails.env.production?
      render_404
    end
  end

  def render_404
    render "errors/not_found", status: :not_found
  end
end
