RedmineApp::Application.routes.draw do
  resources :equipment_assets do
    member do
      get :print
    end
    collection do
      put :print
    end

    resources :asset_check_ins, :only => [:new, :create] do
      member do
        post :new
      end
    end
  end
  match "ci/:equipment_asset_id", :to => "asset_check_ins#new", :as => "equipment_asset_check_in", via: [:get, :post]
end

