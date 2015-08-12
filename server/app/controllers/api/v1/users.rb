module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users do
        desc "Return current user"
        oauth2
        get :whoami do
          resource_owner
        end
      end
    end
  end
end