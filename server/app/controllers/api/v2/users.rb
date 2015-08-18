require 'roar/json'
require 'roar/decorator'

module API
  module V2
    class UserRepresenter < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia

      property :id
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
          current_user = resource_owner
          current_user.email.reverse!

          UserRepresenter.new current_user
        end
      end
    end
  end
end