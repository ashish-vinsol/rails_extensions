Depot::Application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get "sessions/create"
  get "sessions/destroy"
  get "users/orders"
  get "users/line_items"
  get "users/line_items/:page" => "users#line_items"
  get '/my-orders', to: 'users#myorders'
  get '/my-items', to: 'users#line_items'

  resources :products, :path => "books"

  resources :users

  namespace :admin do
    resources :reports, :categories
  end

  resources :products do
    get :who_bought, on: :member
  end

  get '/categories/:id/books', to: 'products#categorise_products', as: :categorise_products

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store', via: :all
  end



end
