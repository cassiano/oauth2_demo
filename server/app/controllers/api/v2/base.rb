module API
  module V2
    class Base < Grape::API
      mount API::V2::Users
      mount API::V2::Tasks

      add_swagger_documentation base_path: '/api/v2',
                                api_version: 'v2',
                                hide_documentation_path: true
    end
  end
end
