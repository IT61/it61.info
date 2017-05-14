module EventsHelper
  def events_fit_on_one_page?(events)
    events.count <= Settings.per_page.events
  end

  def quoted_title(event)
    ["&laquo;", event.title, "&raquo;"].join
  end

  def summary_info(event)
    [quoted_title(event), event.place.full_address, l(event.started_at, format: :date_time_full)].compact.join("<br>")
  end

  def make_global(link)
    unless link.starts_with?("http")
      "http://#{link}"
    end
  end

  def attend_in_event_link(event)
    if Event.upcoming.exists?(event.id)
      link_to "Я пойду", event_attendees_path(event), method: :post, class: "btn btn-shadow btn-blue"
    else
      link_to t("events.participations.participated"), event_attendees_path(event), method: :post, class: "btn btn-shadow btn-blue"
    end
  end

  def registration_link(path)
    link_to t("events.participations.participate"), path, class: "btn btn-shadow btn-blue"
  end

  def remove_from_event_link(event)
    btn_text = event.upcoming? ? "Я не пойду" : t("events.participations.revoke_participation")
    link_to btn_text, event_attendee_path(event), method: :delete, class: "btn btn-shadow btn-blue"
  end

  def to_yandex_location(place)
    {
      addressLine: place.full_address,
      coordinates: [place.latitude, place.longitude],
    }.to_json
  end
end
