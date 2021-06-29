Rails.application.routes.draw do
  
  get 'searches/index'
  
  root to: 'gpathways#index'
  devise_for :users
  resource :user, except: [:new, :create, :destroy]
  
  resources :gpathways do 
    resources :greactions do 
      collection do 
        post 'rdf_upload'
      end
    end
    member do 
      post 'upload'
    end 
  end

end
