module EquipmentAssetsHelper
  def relative_check_in_path(asset)
    s = equipment_asset_check_in_path(asset)
    s.slice!(0)
    s
  end

  def name_and_type(asset)
    h "#{asset.name} (#{asset.asset_type})"
  end
end
