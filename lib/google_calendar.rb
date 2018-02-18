class GoogleCalendar
  def initialize(refresh_token = nil)
    @client = create_client

    if refresh_token
      @client.authorization.grant_type = "refresh_token"
      @client.authorization.refresh_token = refresh_token
      @client.authorization.fetch_access_token!
    else
      @authorizer = create_authorizer
      @authorizer.fetch_access_token!
      @client.authorization = @authorizer
    end
    @service = @client.discovered_api("calendar", "v3")
  end

  def add_event_to_calendar(event)
    payload = JSON.dump(to_calendar_obj(event))
    execute("primary", payload)
  end


  def add_event_to_shared(event)
    payload = JSON.dump(to_calendar_obj(event))
    execute(Rails.application.secrets.google_calendar_id, payload)
  end

  private

  def create_client
    @client = Google::APIClient.new(
      json_key_io: File.open('/Users/vitaly/Downloads/IT61-6864546bb4b0.json'),
      scope: "https://www.googleapis.com/auth/calendar",
      application_name: "IT61.info",
      application_version: "0.1.0"
    )

    @client.authorization.client_id = Rails.application.secrets.google_key
    @client.authorization.client_secret = Rails.application.secrets.google_secret
    @client
  end

  def create_authorizer
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('/Users/vitaly/Downloads/IT61-6864546bb4b0.json'),
      scope: "https://www.googleapis.com/auth/calendar")
    authorizer
  end

  def execute(calendar_id, payload)
    response = @client.execute(
      api_method: @service.events.insert,
      parameters: { calendarId: calendar_id },
      body: payload,
      headers: { "Content-Type" => "application/json" }
    )
    byebug

    response && response.status == 200
  end

  def to_calendar_obj(event)
    {
      summary: event.title,
      location: event.place.full_address,
      description: event.description? ? "" : event.description,
      start: {
        dateTime: event.started_at.iso8601,
      },
      end: {
        dateTime: event.started_at.iso8601,
      },
    }
  end
end
