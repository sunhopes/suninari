Rails.application.routes.draw do
  
  root to: 'gpathways#index'
  devise_for :users
  resource :user, except: [:new, :create, :destroy]
  
  resources :gpathways do 
    resources :greactions
  end

  match 'gpathways/:id', to: 'gpathways#rdf_register', via: [:post]
  
  get 'gpathways/:id', to: 'gpathways#rdf_search'
  #get 'gpathway/top'
  get 'gpathways/upload'
  get 'gpathways/download_file'
 
  
end
