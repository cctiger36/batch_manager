BatchManager::Engine.routes.draw do

  root :to => "batches#index"

  resources :batches do
    collection do
      get :exec
      get :log
    end
  end

end
