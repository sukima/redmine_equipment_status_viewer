class AssetCheckIn < ActiveRecord::Base
  unloadable

  belongs_to :equipment_asset

  validates_presence_of :location, :person, :equipment_asset_id
end
