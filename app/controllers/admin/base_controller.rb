module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :verify_admin

    private

    def current_ability
      @current_ability ||= AdminAbility.new(current_user)
    end

    def verify_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
  end
end
