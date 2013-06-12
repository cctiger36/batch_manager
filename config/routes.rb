BatchManager::Engine.routes.draw do

  root :to => "batches#index"

  resources :batches do
    member do
      get :exec
      get :log
      get :async_read_log
      get :remove_log
    end
  end

end
