# frozen_string_literal: true
class UserDecorator < Draper::Decorator
  delegate_all
  # delegate :member_in_events, :owner_of_events, :full_name, :first_name, :last_name

  def first_name
    "Василий"
  end

  def last_name
    "Батькович"
  end

  def bio
    "Родился в Мосве. Очень очень очень очень очень очень долго жил, поэтому описание обо мне получилось ну очень длинное. Вот и все. Ничего о себе. Я бы не хотел так долго писать, но это нужно для теста. Участвовал во многих войнах, спас 1000 человек. Герой в-общем." # object.bio ||
  end

  def social_account_linked(provider)
    if linked(provider)
      "button-linked"
    else
      "button-not-linked"
    end
  end

  def company_site
    # todo: field
    "https://8deeds.com"
  end

  def company_name
    # todo: field
    "8deeds.com"
  end

  def company_position
    # todo: field
    "Работаю в государственной думе"
  end

  def hash_tag
    # todo: field
    "@Zhirinovsky"
  end

  def has_events?
    not (object.member_in_events.empty? && object.owner_of_events.empty?)
  end

  private

  def linked(provider)
    object.social_accounts.exists?(provider: provider)
  end
end
