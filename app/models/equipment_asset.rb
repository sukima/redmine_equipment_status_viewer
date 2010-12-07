class EquipmentAsset < ActiveRecord::Base
  unloadable
  # These are to allow the controller to manage extra data. It is not used in
  # this model and the values will be ignored.
  # FIXME: This causes:
  #   undefined method `name' for nil:NilClass
  attr_accessor :last_seen_person, :last_seen_location

  has_many :last_seens

  validates_presence_of :name

  def location
    if last_seens && last_seens.last
      last_seens.last.location
    else
      false
    end
  end
end
