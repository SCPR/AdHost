Audiobox::Application.routes.draw do
  get '/pre/p/:key/:stream_key' => "public#preroll"

  namespace :api, defaults: { format: "json" } do
    scope module: "public" do
      namespace :v1 do
        match '/' => "visual_campaigns#options",
          :via            => :options,
          :constraints    => { method: 'OPTIONS' }

        get 'visual_campaigns' => 'visual_campaigns#index'
        get 'visual_campaigns/:key' => 'visual_campaigns#show'
      end
    end
  end

  get "/stream/listeners" => "public#listeners"

  mount Outpost::Engine, at: 'outpost'

  namespace :outpost do
    resources :visual_campaigns

    resources :preroll_campaigns do
      member do
        post :upload
        post :toggle
      end

      resources :audio_encodings, only: :destroy
    end

    get "*path" => 'errors#not_found'
  end

  root to: 'outpost/sessions#new'
end
