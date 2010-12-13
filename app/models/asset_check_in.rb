class AssetCheckIn < ActiveRecord::Base
  unloadable

  # Used to pass information from the new view to the associated
  # equipment_asset.
  attr_accessor :equipment_asset_oos

  belongs_to :equipment_asset

  validates_presence_of :location, :person, :equipment_asset_id
end
