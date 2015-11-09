require 'slack-notifier'

class Event::SlackIntegration
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  def self.instance
    @__instance__ ||= new
  end

  def self.notify(event)
    instance.notify_slack(event)
  end

  def notify_slack(event)
    attachment = build_attachment(event)
    notifier.ping I18n.t('slack_integration.new_event'), attachments: [attachment]
  end

  def notifier
    @notifier ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
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
