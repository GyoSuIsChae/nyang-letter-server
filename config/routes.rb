# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  get "welcome/ping"
  get "error/default"
  get "error/missing"
  match "/500" => "errors#default", via: [:get, :post, :put, :patch, :delete]
  match "/400" => "errors#bad_params", via: [:get, :post, :put, :patch, :delete]
  match "/404" => "errors#missing", via: [:get, :post, :put, :patch, :delete]
  match "/health/ping" => "welcome#ping", via: [:get, :post, :put, :patch, :delete]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "/v1" do
    get "/health/ping", to: "welcome#ping"

    resources :users, controller: :users, param: :uid, only: [:show, :update] do
      post "sign-in", on: :collection, action: :sign_in # /v1/users/sign-up
      resources :cafes, controller: :cafes, param: :uid, only: [:create]
    end
  end
end
