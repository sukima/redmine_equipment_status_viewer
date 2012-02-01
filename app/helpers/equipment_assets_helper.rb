# Redmine Equipment Status Viewer - An equipment manager plugin
# Copyright (C) 2010-2011  Devin Weaver
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module EquipmentAssetsHelper
  def split_path(path)
    m = path.match('^(http[s]?://[^/]+/)(.*)$')
    { :host => m[1], :path => m[2] }
  end

  def split_check_in_url(asset)
    path = split_path(equipment_asset_check_in_url(asset))
    "#{h path[:host]}<br />#{h path[:path]}"
  end

  def name_and_type(asset)
    h "#{asset.name} (#{asset.asset_type})"
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
        str += link_to check_in.equipment_asset.name,
          equipment_asset_path(check_in.equipment_asset)
      else
        str += h(check_in.equipment_asset.name)
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
  
  def assets_grouped_by
    if Setting.plugin_redmine_equipment_status_viewer['assets_grouped_by'].blank?
      "asset_type" # Default value
    else
      Setting.plugin_redmine_equipment_status_viewer['assets_grouped_by']
    end
  end

  def attribute_is_grouped?(group)
    return assets_grouped_by == group.to_s
  end

  def asset_group(asset)
    asset.send(assets_grouped_by)
  end

  def new_asset_group?(asset, group)
    return assets_grouped_by != 'none' && group != asset_group(asset)
  end
end
