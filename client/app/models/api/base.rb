class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken

  delegate :get, to: :access_token, allow_nil: true

  def self.parse_json_response(response)
    JSON.parse response.body
  end

  def load_uri(uri)
    self.class.parse_json_response get(uri)
  end
end
