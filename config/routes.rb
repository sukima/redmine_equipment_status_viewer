ActionController::Routing::Routes.draw do |map| 
#     map.connect 'projects/:project_id/opensearch/:action', :controller => 'opensearch'
  map.resources :equipment_assets, :member => { :print => :get } do |e|
    e.resource :asset_check_ins, :only => [:new, :create], :member => { :new => :post, :loclist => :get }
    e.check_in 'check_in', :controller => 'asset_check_ins', :action => :new
  end
  map.ci 'ci/:equipment_asset_id', :controller => 'asset_check_ins', :action => :new
end
