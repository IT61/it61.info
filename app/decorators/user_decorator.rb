class UserDecorator < Draper::Decorator
  delegate :member_in_events, :owner_of_events, :full_name

  def bio
    'Родился в Мосве. Очень очень очень очень очень очень долго жил, поэтому описание обо мне получилось ну очень длинное. Вот и все. Ничего о себе. Я бы не хотел так долго писать, но это нужно для теста. Участвовал во многих войнах, спас 1000 человек. Герой в-общем.' #object.bio ||
  end

  def social_account_linked(provider)
    if linked(provider)
      'button-linked'
    else
      'button-not-linked'
    end
  end

  def link
    # todo: field
    '8deeds.com'
  end

  def company
    # todo: field
    'Работаю в государственной думе'
  end

  def hash_tag
    # todo: field
    '@Zhirinovsky'
  end

  def has_events?
    not (object.member_in_events.empty? and object.owner_of_events.empty?)
  end

  private

  def linked(provider)
    object.social_accounts.exists?(provider: provider)
  end
end
