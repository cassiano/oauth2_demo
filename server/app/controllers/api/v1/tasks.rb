module API
  module V1
    class Tasks < Grape::API
      include API::V1::Defaults

      resource :tasks do
        desc "Return current user's tasks"
        oauth2
        get do
          resource_owner.tasks
        end
      end
    end
  end
end