require 'roar/json'
require File.expand_path('../tasks', __FILE__)

module API
  module V2
    module UserRepresenter
      include Roar::JSON
      include Roar::Hypermedia

      property :id
      property :email
      collection :tasks, extend: API::V2::TaskRepresenter, class: Task

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