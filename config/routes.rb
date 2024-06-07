Rails.application.routes.draw do
  root 'welcome#index' 

  resources :merchants, only: [:show, :index] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update]
    resources :bulk_discounts, except: [:update]
  end

  patch  "/merchants/:merchant_id/bulk_discounts/:id", to: "bulk_discounts#update"

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: [:new, :destroy]
  end
end
