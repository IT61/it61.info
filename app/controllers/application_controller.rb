class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |_exception|
    Rails.logger.debug "Access denied on #{_exception.action} #{_exception.subject.inspect}"
    throw exception if Rails.env === "development"
    render_404
  end
end
