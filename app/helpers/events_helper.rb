module EventsHelper
  def admin_event_icon_class(event)
    if event.published?
      'fa-eye'
    else
      'fa-eye-slash'
    end
  end
end

