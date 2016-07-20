# frozen_string_literal: true
module UserHelper

  def my_profile?(user)
    user == current_user
  end

  def has_events?(user)
    not (user.member_in_events.empty? && user.owner_of_events.empty?)
  end

  def social_account_linked(user, provider)
    if linked user, provider
      "button-linked"
    else
      "button-not-linked"
    end
  end

  def all_providers
    # hard code for now. get rid of this
    {
        facebook: {
            name: "FACEBOOK",
            class: "fa fa-facebook",
            buttonclass: "btn btn-blue",
            link: "/users/auth/facebook",
        },
        google_oauth2: {
            name: "GOOGLE+",
            class: "fa fa-google-plus",
            buttonclass: "btn btn-red",
            link: "/users/auth/google_oauth2",
        },
        vkontakte: {
            name: "ВКОНТАКТЕ",
            class: "fa fa-facebook",
            buttonclass: "btn btn-blue",
            link: "/users/auth/vkontakte",
        },
        github: {
            name: "GITHUB",
            class: "fa fa-github",
            buttonclass: "btn btn-blue",
            link: "/users/auth/github",
        },
    }
  end

  def linked_providers(user)
    # hard code for now
    {}
  end

  def not_linked_providers(user)
    all_providers
  end

  private

  def linked(user, provider)
    user.social_accounts.exists?(provider: provider)
  end

end
