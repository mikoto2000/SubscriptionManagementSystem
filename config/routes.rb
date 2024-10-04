Rails.application.routes.draw do
  resources :payments
  resources :plan_statuses
  devise_for :accounts

  resources :publisher_accounts
  resources :subscriber_payments
  resources :publisher_payments
  resources :payment_statuses
  resources :subscriptions
  resources :plans
  resources :subscribers
  resources :publishers
  resources :commission_masters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "home#index"
  get "/home/index" => "home#index"
  get "/home/create_plan" => "home#create_plan"
end
