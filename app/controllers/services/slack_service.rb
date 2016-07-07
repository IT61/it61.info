require 'slack-notifier'

# Singletone class

class SlackService

  include ApplicationHelper
  include Rails.application.routes.url_helpers

  def self.instance
    @__instance__ ||= new
  end

  def self.notify(event)
    instance.send_event_notification(event)
  end

  def self.register(user)
    instance.register_new_user(user)
  end

  def send_event_notification(event)
    attachment = build_attachment(event)
    # notifier.ping I18n.t('slack_integration.new_event'), attachments: [attachment]
    notifier.ping 'Анонсировано новое мероприятие', attachments: [attachment]
  end

  def register_new_user(user)
    url = URI(api_url('users.admin.invite', Time.now.to_i))
    Net::HTTP.post_form(url, build_user_invite_params(user))
  end

  private

  def notifier
    @notifier ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  end

  def api_url(action, timestamp)
    ENV['SLACK_TEAM_URL'] << "api/#{action}?t=#{timestamp}"
  end

  # noinspection RubyStringKeysInHashInspection
  def build_user_invite_params(user)
    {
        "email" => user.email,
        "channels" => ENV['SLACK_DEFAULT_CHANNELS'],
        "first_name" => user.full_name,
        # generate token at https://api.slack.com/
        "token" => ENV['SLACK_ADMIN_TOKEN'],
        "set_active" => "true",
        "_attempts" => "1"
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
                value: event.place,
                short: true
            },
            {
                title: Event.human_attribute_name(:started_at),
                value: I18n.l(event.started_at, format: :date_time_full),
                short: true
            }
        ]
    }
  end

end