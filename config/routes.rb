PFLiveEvents::Application.routes.draw do
  mount Apic::Engine => "/apic"
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  get '/health_check' => 'health_check#check'
  get "/test_exception" => "application#test_exception"

  if Rails.env != 'production-admin'

    if Rails.env == 'production'
      # api hardening -- next line to be expanded to only diner dash capable devices
      #constraints(lambda { |req| req.env["HTTP_USER_AGENT"] =~ /iPhone/ }) do

        namespace :api do

          get "/connect" => "connect#index", :as => :connect
          get "/test" => "test#index", :as => :test
          get "/update_score" => "update_score#index", :as => :update_score
          get "/view_leaderboard" => "view_leaderboard#index", :as => :view_leaderboard
          get "/available_awards" => "available_awards#index", :as => :available_awards
          get "/request_award" => "request_award#index", :as => :request_award
          get "/request_token" => "request_token#index", :as => :request_token
      

          #curl -X POST -d "" localhost:3000/api/register_for_pfid      
          post "/register_for_pfid" => "pfid#register_for_pfid"
          #curl -X GET localhost:3000/api/get_pfid
          get "/get_pfid" => "pfid#get_pfid"
        end
      
  end
  if Rails.env != 'production'

      namespace :api do

        get "/connect" => "connect#index", :as => :connect
        get "/test" => "test#index", :as => :test
        get "/update_score" => "update_score#index", :as => :update_score
        get "/view_leaderboard" => "view_leaderboard#index", :as => :view_leaderboard
        get "/available_awards" => "available_awards#index", :as => :available_awards
        get "/request_award" => "request_award#index", :as => :request_award
        get "/request_token" => "request_token#index", :as => :request_token
    

        #curl -X POST -d "" localhost:3000/api/register_for_pfid      
        post "/register_for_pfid" => "pfid#register_for_pfid"
        #curl -X GET localhost:3000/api/get_pfid
        get "/get_pfid" => "pfid#get_pfid"
      end
  end
    
end

  if Rails.env != 'production-api'
    root :controller => :events, :action => :index

    resources :apps, :except => :show
    resources :events, :except => :show
    resources :scores, :except => :show

    devise_scope :user do
      get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
      get 'sign_in', to: redirect('/users/auth/google_oauth2/'), :as => :new_user_session
    end
  end

end
