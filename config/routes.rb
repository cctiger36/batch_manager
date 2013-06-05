Rails.application.routes.draw do
  namespace :batch_manager do
    root :to => "batches#index"

    resources :batches do
      collection do
        get :exec
        get :log
      end
    end
  end
end
