class Api::Base
  include Virtus.model

  attribute :access_token, OAuth2::AccessToken

  delegate :parse_json_response, to: :class

  def self.parse_json_response(response)
    JSON.parse response.body, symbolize_names: true
  end

  def load_resource(uri)
    parse_json_response access_token.get(uri)
  end
end
