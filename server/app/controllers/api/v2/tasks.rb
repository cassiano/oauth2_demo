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

        desc "Search the current user'd tasks by title"
        oauth2
        params do
          requires :title, type: String, desc: 'Task title'
          optional :limit, type: Integer, desc: 'Record limit'
        end
        get :search do
          wildcard_search = "%#{declared(params).title}%"

          resource_owner.tasks.where('title LIKE ?', wildcard_search).limit(declared(params).limit || 100)
        end
      end
    end
  end
end