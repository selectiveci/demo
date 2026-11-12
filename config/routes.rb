Rails.application.routes.draw do
  resources :orders, only: :show do
    post :place, on: :member
  end

  get "up" => "rails/health#show", :as => :rails_health_check
end
