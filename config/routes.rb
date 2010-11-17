ActionController::Routing::Routes.draw do |map| 
#     map.connect 'projects/:project_id/opensearch/:action', :controller => 'opensearch'
  map.resource :equipment_assets
  map.resource :last_seens
end
