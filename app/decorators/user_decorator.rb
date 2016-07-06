class UserDecorator < Draper::Decorator
  delegate :member_in_events, :owner_of_events

  def full_name
    res = ''
    if object.first_name.nil? and object.last_name.nil?
      res = 'Имя не определено'
    end
    unless object.first_name.nil?
      res += object.first_name
    end
    unless object.last_name.nil?
      res += " #{object.last_name}"
    end
    res
  end

  def bio
    'Ничего о себе' #object.bio || 
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

  private

  def linked(provider)
    object.social_accounts.exists?(provider: provider)
  end
end
