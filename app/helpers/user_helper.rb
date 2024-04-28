module UserHelper
  def users_fit_on_one_page?(users)
    users.count <= Settings.per_page.users
  end

  def my_profile?(user)
    user == current_user
  end

  def all_providers
    {
      facebook: {
        name: t("socials.facebook"),
        class: "fa fa-facebook",
        buttonclass: "btn btn-fb",
        link: user_facebook_omniauth_authorize_path,
      },
      google_oauth2: {
        name: t("socials.google_plus"),
        class: "fa fa-google-plus",
        buttonclass: "btn btn-google",
        link: user_google_oauth2_omniauth_authorize_path,
      },
      vkontakte: {
        name: t("socials.vk"),
        class: "fa fa-vk",
        buttonclass: "btn btn-vk",
        link: user_vkontakte_omniauth_authorize_path,
      },
      github: {
        name: t("socials.github"),
        class: "fa fa-github",
        buttonclass: "btn btn-github",
        link: user_github_omniauth_authorize_path,
      },
    }
  end

  def provider_buttons_info(user)
    accounts = user.social_accounts
    res = {}
    accounts.each do |a|
      provider = a.provider.to_sym
      link = a.link
      button_class = all_providers[provider][:class]
      res[provider] = [link, button_class] unless link.nil?
    end
    res
  end

  def default_avatar_url
    CGI.escape(image_url("user_default.svg"))
  end

  def photo(user)
    user.avatar.file.nil? ? image_url("user_default.png") : user.avatar_url(:square_250)
  end
end
