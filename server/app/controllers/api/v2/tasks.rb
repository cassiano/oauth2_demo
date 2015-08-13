module API
  module V2
    class Tasks < Grape::API
      include API::V2::Defaults

      resource :tasks do
        desc "Return current user's tasks"
        oauth2
        get do
          resource_owner.tasks.order('id DESC')
        end
      end
    end
  end
end