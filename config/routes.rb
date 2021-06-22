Rails.application.routes.draw do
  resources :alerts
  root 'panel#index'
  get "/gateway_hardware", to: "hardware#index"
  post "/gateway_status", to: "gateway_status#create"
  post "/gateway_hardware", to: "hardware#create"
  post "/gateway_alive", to: "gateway_alive#create"
  get "/gateway_alive", to: "gateway_alive#index"
  get "/notifications", to: "notifications#index"
  get "/notifications/:id", to: "notifications#show"
  get "/panel", to: "panel#index"
  put "/panel/:id", to: "panel#update"
  get "/emails", to: "emails#index"
  post "/emails", to: "emails#create"
  delete "/emails/:id", to: "emails#destroy"
  get "/graphs", to:"graphs#index"
  get "/login", to:"login#index"
  get "/clients", to:"clients#index"

  devise_for :users, controllers: {
  sessions: 'users/sessions'
  }
end
