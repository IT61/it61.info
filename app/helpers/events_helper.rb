module EventsHelper
  def summary_info(event)
    "&laquo;#{event.title}&raquo;, #{event.started_at}<br>#{event.places.first.full_address}"
  end

  def make_global(link)
    unless link.starts_with?("http")
      "http://#{link}"
    end
  end

  def participate_in_event_link(event)
    if Event.upcoming.exists?(event)
      if event.opened?
        link_to t("events.participations.participate"), participate_event_path(event), method: :post, class: "btn btn-shadow btn-blue"
      else
        link_to t("events.participations.register"), register_to_event_path(event), class: "btn btn-shadow btn-blue"
      end
    else
      link_to t("events.participations.participated"), participate_event_path(event), method: :post, class: "btn btn-shadow btn-blue"
    end
  end

  def revoke_registration_link(event)
    link_to t("events.participations.revoke_participation"), revoke_participation_event_path(event), method: :delete, class: "btn btn-shadow btn-blue"
  end
end
