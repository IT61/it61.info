class CompanyDecorator < Draper::Decorator
  delegate_all

  def membership_submit_title
    h.t('.membership_submit_title')
  end

  def cancel_membership_submit_title
    h.t('.cancel_membership_submit_title')
  end
end
