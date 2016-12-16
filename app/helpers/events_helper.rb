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

  def event_organizer?(event, user)
    return false if event.blank? || user.blank?
    event.organizer_id == user.id
  end

  def participate_in_event_link(event)
    if Event.upcoming.exists?(event.id)

      if event.has_closed_registration?
        registration_link(register_to_event_path(event))
      else
        registration_link(participate_event_path(event))
      end
    else
      link_to t("events.participations.participated"), event_participation_path(event), class: "btn btn-shadow btn-blue"
    end
  end

  def registration_link(path)
    link_to t("events.participations.participate"), path, class: "btn btn-shadow btn-blue"
  end

  def revoke_registration_link(event)
    link_to t("events.participations.revoke_participation"), leave_event_path(event), class: "btn btn-shadow btn-blue"
  end

  def to_yandex_location(place)
    {
      addressLine: place.full_address,
      coordinates: [place.latitude, place.longitude],
    }.to_json
  end
end
