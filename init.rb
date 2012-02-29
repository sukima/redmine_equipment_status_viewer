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

require 'redmine'

Redmine::Plugin.register :redmine_equipment_status_viewer do
  name 'Redmine Equipment Status Viewer plugin'
  author 'Devin Weaver'
  description 'Allows admins to make a list of equipment and track if they are inservice or not'
  version '0.3.6'
  url 'http://sukima.github.com/redmine_equipment_status_viewer'
  author_url 'http://github.com/sukima'

  permission :view_equipment_assets, {:equipment_assets => [:index, :show, :print]}
  permission :manage_equipment_assets, {:equipment_assets => [:destroy, :update, :create, :edit, :new]}
  permission :allow_equipment_check_ins, {:asset_check_ins => [ :new, :create, :loclist ]}

  settings(:partial => 'equipment_status_viewer_settings',
           :default => {
             'assets_grouped_by' => 'asset_type'
           })

  menu :top_menu, "Equipment",
    { :controller => 'equipment_assets', :action => 'index' },
    :caption => :equipment_label, :after => :projects,
    :if => Proc.new {
      User.current.allowed_to?(:view_equipment_assets, nil, :global => true)
    }
end
