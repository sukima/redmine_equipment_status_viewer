class EquipmentAsset < ActiveRecord::Base
  unloadable

  validates_presence_of :name
end
