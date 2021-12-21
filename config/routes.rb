Rails.application.routes.draw do
  root to: "notes#index"
  devise_for :users , controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/create', to: 'notes#create'

  get '/edit', to: 'notes#edit'

  patch '/update', to: 'notes#update'

  delete '/destroy', to: 'notes#destroy'
end
