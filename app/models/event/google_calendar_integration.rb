require 'google/api_client'
require 'google/api_client/auth/file_storage'

class Event::GoogleCalendarIntegration
  include Rails.application.routes.url_helpers

  attr_reader :event

  def initialize(event)
    if event.is_a? Event
      @event = event
    else
      @event = Event.find(event)
    end
  end

  def self.create(event)
    instance = new(event)
    instance.save
    instance
  end

  def save
    event_json = {
      'summary' => event.title,
      'location' => event.place,
      'source' => {
        'title' => event.title,
        'url' => event_url(event, host: ENV['APP_HOST'])
      },
      'start' => {
        'dateTime' => event.started_at.to_datetime.rfc3339
      },
      'end' => {
        'dateTime' => event.started_at.since(2.hours).to_datetime.rfc3339
      },
    }

    result = client.execute(api_method: calendar_api.events.insert,
                            parameters: { 'calendarId' => Rails.application.secrets.calendar_id },
                            body: JSON.dump(event_json),
                            headers: { 'Content-Type' => 'application/json' })

    if result.status == 200
      event.published_to_google_calendar = true
      event.google_calendar_id = JSON.parse(result.body)['id']
      event.save!
      update_credentials_file!
    end
    result
  end

  def delete
    result = client.execute(api_method: calendar_api.events.delete,
                            parameters: { 'calendarId' => Rails.application.secrets.calendar_id,
                                          'eventId' => event.google_calendar_id })
    if result.status == 204
      event.published_to_google_calendar = false
      event.google_calendar_id = nil
      event.save!
      update_credentials_file!
    else
      fail "Event::GoogleCalendarIntegration#delete failed with status #{result.status}"
    end
  end

  private

  def client
    unless @client
      @client = Google::APIClient.new(
        application_name: 'IT61 calendar notifications',
        application_version: '1.0.0',
        auto_refresh_token: true
      )
      @client.authorization = credentials_file.authorization
      @client.authorization.update_token!
    end
    @client
  end

  def credentials_file
    unless @credentials_file
      path = Rails.root.join('config/calendar_oauth2.json')
      @credentials_file = Google::APIClient::FileStorage.new(path)
      if @credentials_file.authorization.nil?
        fail 'Event::GoogleCalendarIntegration#credentials_file cannot authorize access to calendar'
      end
    end
    @credentials_file
  end

  def update_credentials_file!
    credentials_file.write_credentials
  end

  def calendar_api
    @calendar_api ||= client.discovered_api('calendar', 'v3')
  end
end
