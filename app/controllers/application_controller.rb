class ApplicationController < ActionController::Base
  include Styx::Initializer

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, with: :deny_access

  protected
    def deny_access(exception)
      redirect_to root_url, flash: { error: exception.message }
    end
end
