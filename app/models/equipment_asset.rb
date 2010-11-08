class EquipmentAsset < ActiveRecord::Base
  unloadable
  has_many :last_seens

  validates_presence_of :name

  def location
    if last_seens.last
      last_seens.last.location
    else
      false
    end
  end
end
