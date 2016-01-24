class CompanyDecorator < Draper::Decorator
  delegate_all

  def membership_request_submit_title
    h.t('.membership_request_submit_title')
  end

  def cancel_membership_submit_title
    h.t('.cancel_membership_submit_title')
  end

  def request_exist_notice(user)
    fomatted_date = h.l(request_for(user).created_at, format: :date_time_digits)
    h.t('.request_exist', at: fomatted_date)
  end
end
