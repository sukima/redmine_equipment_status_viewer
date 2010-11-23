class LastSeensController < ResourceController::Singleton
  unloadable
  # REST actions: index, new, create, show, edit, update, destroy
  # No index action in singleton controllers
  actions :all, :except => [ :destroy, :show, :edit, :update ]
end
