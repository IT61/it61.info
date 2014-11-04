require 'google/api_client'
require 'google/api_client/auth/file_storage'

class Event::GoogleCalendarIntegration
  include Rails.application.routes.url_helpers

  def self.create(event)
    instance = new
    instance.save(event)
    instance
  end


  def save(event)
    event = Event.find(event) unless event.is_a? Event

    event_json = {
      'summary' => event.title,
      'location' => event.place,
      # TODO: Убрать хардкод хоста.
      'url' => event_url(event, host: 'http://it61.info'),
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
      event.save!
      update_credentials_file!
    end
    result
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
