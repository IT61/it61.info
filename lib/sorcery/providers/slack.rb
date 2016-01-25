module Sorcery
  module Providers
    # This class adds support for OAuth with github.com.
    #
    #   config.github.key = <key>
    #   config.github.secret = <secret>
    #   ...
    #
    class Github < Base

      include Protocols::Oauth2

      attr_accessor :auth_path, :scope, :token_url, :user_info_path

      def initialize
        super

        @scope          = nil
        @site           = 'https://github.com/'
        @user_info_path = 'https://api.github.com/user'
        @auth_path      = '/login/oauth/authorize'
        @token_url      = '/login/oauth/access_token'
      end

      def get_user_hash(access_token)
        response = access_token.get(user_info_path)

        auth_hash(access_token).tap do |h|
          h[:user_info] = JSON.parse(response.body).tap do |uih|
            uih['email'] = primary_email(access_token) if scope =~ /user/
          end

          h[:uid] = h[:user_info]['id']
          name: user_info['user'].to_h['profile'].to_h['real_name_normalized'],
          email: user_info['user'].to_h['profile'].to_h['email'],
          nickname: raw_info['user'],
          first_name: user_info['user'].to_h['profile'].to_h['first_name'],
          last_name: user_info['user'].to_h['profile'].to_h['last_name'],
          description: user_info['user'].to_h['profile'].to_h['title'],
          image_24: user_info['user'].to_h['profile'].to_h['image_24'],
          image_48: user_info['user'].to_h['profile'].to_h['image_48'],
          image: user_info['user'].to_h['profile'].to_h['image_192'],
          team: raw_info['team'],
          user: raw_info['user'],
          team_id: raw_info['team_id'],
          team_domain: team_info['team'].to_h['domain'],
          user_id: raw_info['user_id'],
          is_admin: user_info['user'].to_h['is_admin'],
          is_owner: user_info['user'].to_h['is_owner'],
          time_zone: user_info['user'].to_h['tz']
        end
      end

      # calculates and returns the url to which the user should be redirected,
      # to get authenticated at the external provider's site.
      def login_url(params, session)
        authorize_url({ authorize_url: auth_path })
      end

      # tries to login the user from access token
      def process_callback(params, session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end

        get_access_token(args, token_url: token_url, token_method: :post)
      end

      def primary_email(access_token)
        response = access_token.get(user_info_path + "/emails")
        emails = JSON.parse(response.body)
        primary = emails.find{|i| i['primary'] }
        primary && primary['email'] || emails.first && emails.first['email']
      end

    end
  end
end
