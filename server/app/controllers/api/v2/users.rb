require 'roar/json'

module API
  module V2
    module UserRepresenter
      include Roar::JSON
      include Roar::Hypermedia

      property :email

      link :tasks do
        'api/v2/tasks.json'
      end

      link :search do
        'api/v2/tasks/search.json'
      end
    end

    class Users < Grape::API
      include API::V2::Defaults

      resource :users do
        desc 'Return current user'
        oauth2
        get :whoami do
          resource_owner.extend(UserRepresenter).tap do |user|
            user.email.reverse!
          end
        end
      end
    end
  end
end