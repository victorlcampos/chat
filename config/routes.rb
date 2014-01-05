Chat::Application.routes.draw do
  resources :messages, only: [:index, :create] do
    get :subscription, on: :collection
  end
  root 'messages#index'
end
