ActionController::Routing::Routes.draw do |map| 
#     map.connect 'projects/:project_id/opensearch/:action', :controller => 'opensearch'
  map.resources :equipment_assets
  map.resources :last_seens
end
