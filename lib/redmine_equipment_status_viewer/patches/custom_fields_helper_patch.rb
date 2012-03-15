# Redmine Equipment Status Viewer - An equipment manager plugin
# Copyright (C) 2012  Devin Weaver
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

module RedmineEquipmentStatusViewer
  module Patches
    module CustomFieldsHelperPatch
      def self.include(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :custom_fields_tabs, :equipment_assets_tab
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def custom_fields_tabs_with_equipment_assets_tab
          tabs = custom_fields_tabs_without_equipment_assets_tab
          tabs << {:name => 'EquipmentAssetCustomField', :partial => 'custom_fields/index', :label => :equipment_assets}
          return tabs
        end
      end
    end
  end
end
