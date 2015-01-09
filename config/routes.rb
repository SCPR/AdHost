require "resque/server"

AdHost::Application.routes.draw do
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
    resque_constraint = ->(request) do
      user_id = request.session.to_hash["user_id"]

      if user_id && u = User.find_by(:id => user_id)
        u.is_superuser?
      else
        false
      end
    end

    constraints resque_constraint do
      mount Resque::Server.new, :at => "resque"
    end
    resources :visual_campaigns
    resources :users

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
