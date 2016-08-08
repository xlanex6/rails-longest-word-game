Rails.application.routes.draw do
  get '/game' => 'biggle#game'
  get '/score' => 'biggle#score'
  root 'biggle#game', as: 'home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
