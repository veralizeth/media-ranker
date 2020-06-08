Rails.application.routes.draw do
  root to: "pages#home"

  resources :works do
    resources :votes, only: [:create]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"
  # post "/logout", to: "users#logout", as: "logout"
  delete "/logout", to: "users#destroy", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"
  # The get '/auth/github' is a special path that OmniAuth is looking for.
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
 

  resources :users

end
