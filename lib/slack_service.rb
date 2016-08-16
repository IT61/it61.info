require "slack-notifier"
class SlackService
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  def self.instance
    @__instance__ ||= new
  end

  def self.notify(event)
    instance.send_event_notification(event)
  end

  def self.invite(user)
    instance.invite_new_user(user)
  end

  def send_event_notification(event)
    return unless service_configured?
    attachment = build_attachment(event)
    # notifier.ping I18n.t('slack_integration.new_event'), attachments: [attachment]
    notifier.ping "Анонсировано новое мероприятие", attachments: [attachment]
  end

  def invite_new_user(user)
    return unless service_configured?

    url = URI.parse(raw_api_url("users.admin.invite"))
    params = build_user_invite_params(user)
    response = Net::HTTP.post_form(url, params)

    case response
    when Net::HTTPOK
      json_response = JSON.parse(response.body)
      was_sent = json_response["ok"]
      error = json_response["error"]
      { success: was_sent, error: error }
    else
      { success: false, error: response }
    end
  end

  private

  def service_configured?
    keys = ["SLACK_TEAM_DOMAIN", "SLACK_WEBHOOK_URL", "SLACK_DEFAULT_CHANNELS", "SLACK_ADMIN_TOKEN"].freeze
    keys.none? { |k| ENV[k].nil? }
  end

  def raw_api_url(action)
    "https://#{ENV['SLACK_TEAM_DOMAIN']}/api/#{action}"
  end

  def notifier
    @notifier ||= Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"])
  end

  # noinspection RubyStringKeysInHashInspection
  def build_user_invite_params(user)
    {
      "email" => user.email,
      "token" => ENV["SLACK_ADMIN_TOKEN"],
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "channels" => ENV["SLACK_DEFAULT_CHANNELS"],
    }
  end

  def build_attachment(event)
    text = plain_text(event.description)
    {
      title: event.title,
      title_link: event_url(event),
      thumb_url: event.title_image.url(:square_500),
      text: text,
      fallback: text,
      color: :good,
      fields: [
        {
          title: Event.human_attribute_name(:place),
          value: event.place.full_address,
          short: true,
        },
        {
          title: Event.human_attribute_name(:started_at),
          value: I18n.l(event.started_at, format: :date_time_full),
          short: true,
        },
      ],
    }
  end
end
