class LastSeen < ActiveRecord::Base
  unloadable

  belongs_to :equipment_asset

  validates_presence_of :location
end
