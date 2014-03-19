Audiobox::Application.routes.draw do
  match '/pre/p/:key/:stream_key' => "public#preroll"

  namespace :api, defaults: { format: "json" } do
    scope module: "public" do
      namespace :v1 do
        match '/' => "visual_campaigns#options", constraints: { method: 'OPTIONS' }

        get 'visual_campaigns/:key' => 'visual_campaigns#show'
      end
    end
  end

  match "/stream/listeners" => "public#listeners"

  namespace :outpost do
    root to: 'home#index'

    resources :visual_campaigns

    resources :preroll_campaigns do
      member do
        post :upload
        post :toggle
      end
    end

    resources :sessions, only: [:create, :destroy]
    get 'login' => 'sessions#new', as: :login
    get 'logout' => 'sessions#destroy', as: :logout
  end

  root to: 'outpost/sessions#new'
end
