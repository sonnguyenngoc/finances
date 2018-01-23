Erp::Finances::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/finances" do
      resources :services do
        collection do
          get 'dataselect'
          post 'list'
          delete 'delete_all'
        end
      end
    end
  end
end