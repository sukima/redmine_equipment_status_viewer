class LastSeensController < ActionController::Base
  unloadable
  resource_controller :singleton

  # REST actions: index, new, create, show, edit, update, destroy
  # No index action in singleton controllers
  actions :all, :except => [ :destroy, :show, :edit, :update ]
end
