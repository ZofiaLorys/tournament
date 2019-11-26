# frozen_string_literal: true

Rails.application.routes.draw do
  resources 'teams'
  resources 'matches'
  post '/matches/update', to: 'matches#update', as: 'matches_update'
end
