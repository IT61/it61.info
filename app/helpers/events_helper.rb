# frozen_string_literal: true
module EventsHelper

  def summary_info(event)
    "&laquo;#{event.title}&raquo;, #{event.started_at}<br>#{event.places.first.full_address}"
  end

  def make_global(link)
    unless link.starts_with?('http')
      "http://#{link}"
    end
  end

end
