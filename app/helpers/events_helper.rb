module EventsHelper
  def quoted_title
    ["&laquo;", event.title, "&raquo;"].join
  end

  def summary_info(event)
    [quoted_title, event.place.full_address, event.started_at].compact.join("<br>")
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

  def to_yandex_location(place)
    {
        addressLine: place.full_address,
        coordinates: [place.latitude, place.longitude]
    }.to_json
  end
end
