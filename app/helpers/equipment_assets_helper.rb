module EquipmentAssetsHelper
  def relative_check_in_path(asset)
    s = check_in_equipment_asset_path(asset)
    s.slice!(0)
    s
  end
end
