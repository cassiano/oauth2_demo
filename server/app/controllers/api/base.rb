module API
  class Base < Grape::API
    use ::WineBouncer::OAuth2

    mount API::V1::Base
    mount API::V2::Base
  end
end
