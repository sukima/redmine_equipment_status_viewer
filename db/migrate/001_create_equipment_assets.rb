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

class CreateEquipmentAssets < ActiveRecord::Migration[4.2]
  def self.up
    create_table :equipment_assets do |t|
      t.column :name, :string
      t.column :oos, :boolean, :null => false, :default => false
      t.column :asset_type, :string
      t.column :serial_number, :string
    end
  end

  def self.down
    drop_table :equipment_assets
  end
end
