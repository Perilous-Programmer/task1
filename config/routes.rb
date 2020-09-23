Rails.application.routes.draw do
  resources :shopping_carts
  resources :products
  get  'addtocart/:id/:qty', to: 'shopping_carts#addtocart'
  post 'addtocart/:id/:qty', to: 'shopping_carts#addtocart'
  get  'removefromcart/:id/:qty', to: 'shopping_carts#removefromcart'
  post 'removefromcart/:id/:qty', to: 'shopping_carts#removefromcart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
