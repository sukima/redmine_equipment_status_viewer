class LastSeensController < ResourceController::Base
  unloadable
  actions [:create, :new]
end
