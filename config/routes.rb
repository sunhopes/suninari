Rails.application.routes.draw do
  
  root to: 'gpathways#index'
  devise_for :users
  resource :user, except: [:new, :create, :destroy]
  
  resources :gpathways do 
    resources :greactions
  end
  get 'gpathways/upload'
  get 'gpathways/download_file'
  #resources :greactons, only: [:edit]
  
end
