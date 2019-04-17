Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'items#index'

  get 'imports', to: 'items#import'

  resources :items, only: [:index, :show] do
    collection do
      get 'import'
    end
  end  
end
