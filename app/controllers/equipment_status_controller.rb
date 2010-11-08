class EquipmentStatusController < ApplicationController
  unloadable

  def index
    @assets = EquipmentAsset.all
  end
end
