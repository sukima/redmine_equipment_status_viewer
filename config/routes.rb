# Found redmine-1.4 -> redmine-2.1 infor from http://www.redmine.org/boards/3/topics/30423
RedmineApp::Application.routes.draw do
  # Redmine-2.1 uses Rails 3 which has a new routing DSL.
  # Info found from http://www.engineyard.com/blog/2010/the-lowdown-on-routes-in-rails-3/
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
        get :loclist
      end
      # match "check_in", :to => "asset_check_ins#new", :as => "check_in"
    end
  end
  match "/ci/:equipment_asset_id", :to => "asset_check_ins#new", :as => "equipment_asset_check_in"
end
