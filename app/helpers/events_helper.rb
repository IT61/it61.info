module EventsHelper
  def admin_event_icon_class(event)
    if event.published?
      'fa-check'
    else
      'fa-times'
    end
  end
end

