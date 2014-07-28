Rails.application.routes.draw do
  root :to => 'sessions#show'
      
  #Login Twitter
  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  get '/auth/failure', to: 'sessions#error', as: 'failure'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  #Rutas
  get '/landpage', to: 'landpage#index'
  get '/home', to: 'home#index'
  get '/tablon/:hashtag', to: 'tablon#index'
  get '/nuevo_tablon', to: 'nuevotablon#index'

  get '/crear_tablon/:hashtag', to: 'application#creartablon'
  get '/borrar_tablon/:hashtag', to: 'application#borrartablon' 
  
  get '/sendtweet', to: 'application#sendtweet'  
end
