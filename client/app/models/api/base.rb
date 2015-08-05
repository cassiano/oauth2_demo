class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken

  def load_resource(uri, params = {})
    access_token.get(uri, params: params).parsed
  end
end
