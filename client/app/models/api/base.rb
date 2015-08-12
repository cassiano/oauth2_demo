class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken

  def self.load_resource(access_token, uri, params = {})
    access_token.get(uri, params: params).parsed
  end

  def load_resource(uri, params = {})
    self.class.load_resource(access_token, uri, params)
  end
end
