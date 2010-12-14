module EquipmentAssetsHelper
  def split_path(path)
    m = path.match('^(http://[^/]+/)(.*)$')
    { :host => m[1], :path => m[2] }
  end

  def split_check_in_url(asset)
    path = split_path(equipment_asset_check_in_url(asset))
    "#{h path[:host]}<br />#{h path[:path]}"
  end

  def name_and_type(asset)
    h "#{asset.name.capitalize} (#{asset.asset_type})"
  end

  def simple_date(time)
    # FIXME: This is not i18n compatable!
    time.strftime("%a %m/%d %H:%M")
  end
end
