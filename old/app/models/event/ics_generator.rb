class Event::IcsGenerator
  include Rails.application.routes.url_helpers

  attr_reader :event

  def initialize(event)
    @event = event
  end

  def ics_content
    calendar_event = Icalendar::Event.new
    calendar_event.dtstart = event.started_at.strftime('%Y%m%dT%H%M%S')
    calendar_event.summary = event.title
    calendar_event.description = event.description
    calendar_event.location = event.place
    calendar_event.created = event.created_at
    calendar_event.last_modified = event.updated_at
    calendar_event.uid = event_url(event)
    calendar_event.url = event_url(event)

    alarm_dates = [
      # Оповещаем о событии за сутки в 12:00.
      event.started_at.ago(1.day).change({hour: 12, min: 0, sec: 0}),
      # За 6 часов до наступления события.
      event.started_at.ago(6.hours),
      # За 3 часа до наступления события.
      event.started_at.ago(3.hours)
    ]

    alarm_dates.each do |alarm_date|
      alarm = Icalendar::Alarm.new
      alarm.action = 'AUDIO'
      alarm.trigger = Icalendar::Values::DateTime.new(alarm_date)
      calendar_event.alarms << alarm
    end

    calendar = Icalendar::Calendar.new
    calendar.add_event(calendar_event)
    calendar.to_ical
  end

  def conten_type
    Mime[:ics].to_s
  end

  def file_name
    @event.to_param + '.ics'
  end
end
