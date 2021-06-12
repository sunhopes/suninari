Rails.application.routes.draw do
  
  get 'searches/index'
  
  root to: 'gpathways#index'
  devise_for :users
  resource :user, except: [:new, :create, :destroy]
  
  resources :gpathways do 
    resources :greactions 
  end
  match 'gpathways/:gpathway_id/', to: 'greactions#rdf_upload', via: [:post]
  
  #get 'gpathway/top'
  get 'gpathways/upload'
  get 'gpathways/download_file'
 
  
end
