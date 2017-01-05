module Admin
  class BaseController < ApplicationController
    before_action :verify_admin

    private

    def verify_admin
      raise ActionController::RoutingError.new("Not Found") unless current_user.try(:admin?)
    end
  end
end
