class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(_resource_or_scope)
    current_user.fresh? ? sign_up_complete_path : events_path
  end

  def welcome
  end

  def render_403
    render status: :forbidden, text: "Forbidden access"
  end

  def render_404
    render "errors/not_found", status: :not_found
  end

  def authenticate_admin!
    authenticate_user!

    if current_user.nil? || (not current_user.admin?)
      raise CanCan::AccessDenied
    end
  end

  rescue_from CanCan::AccessDenied do |_exception|
    render_404
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render_404
  end

  rescue_from ActionView::MissingTemplate do |_exception|
    render_404
  end
end
