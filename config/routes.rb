BatchManager::Engine.routes.draw do

  root :to => "batches#index"

  resources :batches do
    collection do
      get :exec
      get :log
      get :async_read_log
    end
  end

end
