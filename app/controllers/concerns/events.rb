require 'active_support/concern'

module Events
  extend ActiveSupport::Concern
  included do

    def show_events(scope, include_unpublished = false)
      @events = Event.send(scope).paginate(page: params[:page], per_page: Settings.per_page.events).eager_load(:place)
      @events = @events.published unless include_unpublished
      @scope = scope

      view = request.xhr? ? "events/cards/_card" : "events/index"
      respond_with @events do |f|
        f.html { render view, layout: !request.xhr? }
      end
    end

  end
end
