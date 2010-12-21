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

  def print_check_in(check_in, opt = {})
    opt[:link] ||= false
    opt[:fuzzy_date] ||= true
    all_details = [ :name, :location, :person, :date ]
    only, except = opt.values_at(:only, :except)
    if only == :all || except == :none
      details = all_details
    # Having no details makes no sense in this context.
    # elsif only == :none || except == :all
    #   details = [ ]
    elsif only
      details = (only.kind_of? Array) ? only : [ only ]
    elsif except
      except = [ except ] if !except.kind_of? Array
      details = all_details.select {|d| !except.include?(d)}
    else
      details = [ :location, :person, :date ]
    end

    str = ""
    if check_in.equipment_asset && details.include?(:name)
      if opt[:link]
        str += link_to check_in.equipment_asset.name.capitalize,
          equipment_asset_path(check_in.equipment_asset)
      else
        str += h(check_in.equipment_asset.name.capitalize)
      end
      str += " was checked in"
    else
      str += "Checked in"
    end
    if details.include?(:date)
      if opt[:fuzzy_date]
        str += " <acronym title=\"#{h simple_date(check_in.created_at)}\">#{distance_of_time_in_words(Time.now, check_in.created_at)}</acronym> ago"
      else
        str += " on #{h simple_date(check_in.created_at)}"
      end
    end
    if details.include?(:location)
      str += " at <strong>#{h check_in.location}</strong>"
    end
    if details.include?(:person)
      str += " by <em>#{h check_in.person}</em>"
    end
    str += "."
  end
end
