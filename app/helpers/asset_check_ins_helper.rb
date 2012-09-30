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
  def edit_button_for(asset)
    link_to t(:edit), edit_equipment_asset_path(asset), { 'data-icon' => "gear", :class => "ui-btn-right" }
  end

  def check_in_button_for(asset)
    link_to t(:lable_chek), equipment_asset_check_in_path(asset), { 'data-icon' => "check", :class => "ui-btn-right" }
  end

  def oss_slider_for(asset, field)
    asset.select field, {"No" => false, "Yes" => true}, {}, {"data-role" => "slider"}
  end
end
