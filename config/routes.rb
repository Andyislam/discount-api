# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers do 
      	get '/transaction_total' => 'customer#transaction_total'
      end
    end
  end
end
