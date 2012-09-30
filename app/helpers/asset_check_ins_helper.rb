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

module AssetCheckInsHelper
  def jqm_button(text, href, options = {})
    jqm_data = { 'data-role' => "button" }
    jqm_data.merge!(options.except(:icon,:pos,:footer))
    jqm_data['data-icon'] = options[:icon] if options.has_key?(:icon)
    if options[:pos] && options[:pos][0].upcase == "R"
      jqm_data[:class] = "" unless jqm_data.has_key?(:class)
      jqm_data[:class] += " ui-btn-right"
    end
    if options[:footer]
      jqm_data['data-mini'] = "true"
      jqm_data['data-ajax'] = "false"
    end
    link_to text, href, jqm_data
  end

  def edit_button_for(asset)
    jqm_button t(:edit), edit_equipment_asset_path(asset), { :icon => "gear", :pos => "r" }
  end

  def check_in_button_for(asset)
    jqm_button t(:lable_chek), equipment_asset_check_in_path(asset), { :icon => "check", :pos => "r" }
  end

  def oss_slider_for(asset, field)
    asset.select field, {"No" => false, "Yes" => true}, {}, {"data-role" => "slider"}
  end
end
