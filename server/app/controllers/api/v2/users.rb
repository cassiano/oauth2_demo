module API
  module V2
    class Users < Grape::API
      include API::V2::Defaults

      resource :users do
        desc "Return current user"
        oauth2
        get :whoami do
          resource_owner.tap do |user|
            user.email.reverse!
          end
        end
      end
    end
  end
end