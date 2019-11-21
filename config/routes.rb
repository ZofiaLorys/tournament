# frozen_string_literal: true

Rails.application.routes.draw do
  resources 'teams'
  #get '/teams', to: 'teams#create_multiple', as: 'create_multiple_teams'
  post '/teams/create_multiple', to: 'teams#create_multiple', as: 'create_multiple_teams'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
