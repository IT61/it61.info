class EventDecorator < Draper::Decorator
  delegate_all

  def title_with_date
    formatted_date = I18n.l(started_at, format: :date_digits)
    "#{title} (#{formatted_date})"
  end

  def participate_submit_title
    if past?
      h.t('.participate_past_submit_title')
    else
      h.t('.participate_submit_title')
    end
  end

  def cancel_participation_submit_title
    if past?
      h.t('.cancel_past_participation_submit_title')
    else
      h.t('.cancel_participation_submit_title')
    end
  end
end
