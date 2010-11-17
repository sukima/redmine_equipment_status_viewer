class EquipmentAssetsController < ResourceController::Base
  unloadable

  index.before do
    @lastseen_list = LastSeen.find(:all, :order => "id desc", :limit => 20)
  end
end
