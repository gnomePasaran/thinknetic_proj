Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  get '/final_signup' => 'registrations#final_signup', as: :final_signup
  patch '/final_signup' => 'registrations#send_confirmation_email', as: :send_confirmation_email

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  resources :questions, concerns: :votable, except: [:edit], shallow: true do
    resources :comments, only: [:create], defaults: { commentable: 'questions' }
    resources :answers, only: [:create, :update, :destroy], concerns: :votable do
      resources :comments, only: [:create], defaults: { commentable: 'answers' }
      member do
        get :toggle_best
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show]
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
