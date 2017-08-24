require 'action_controller/metal/http_authentication'

module Authorization
  extend ActiveSupport::Concern
  included do
    include ActionController::HttpAuthentication::Token::ControllerMethods

    private

    # NOTE: this code is from here:
    # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Token.html
    def authorize
      return true if Rails.env.development?
      auth_token = ENV['MONNY_AUTH_TOKEN']
      authenticate_or_request_with_http_token do |token, _options|
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(token), ::Digest::SHA256.hexdigest(auth_token)
        )
      end
    end
  end
end
