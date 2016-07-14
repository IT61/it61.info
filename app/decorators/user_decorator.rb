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

  def all_providers
    # hard code for now. get rid of this
    {
        facebook: {
            name: 'FACEBOOK',
            class: 'fa fa-facebook',
            buttonclass: 'btn btn-blue',
            link: '/users/auth/facebook'
        },
        google_oauth2: {
            name: 'GOOGLE+',
            class: 'fa fa-google-plus',
            buttonclass: 'btn btn-red',
            link: '/users/auth/google_oauth2'
        },
        vkontakte: {
            name: 'ВКОНТАКТЕ',
            class: 'fa fa-facebook',
            buttonclass: 'btn btn-blue',
            link: '/users/auth/vkontakte'
        },
        github: {
            name: 'GITHUB',
            class: 'fa fa-github',
            buttonclass: 'btn btn-blue',
            link: '/users/auth/github'
        }
    }
  end

  def linked_providers
    # hard code for now
    {}
  end

  def not_linked_providers
    all_providers
  end

  private

  def linked(provider)
    object.social_accounts.exists?(provider: provider)
  end
end
