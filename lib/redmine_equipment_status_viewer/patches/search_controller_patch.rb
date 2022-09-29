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
    module SearchControllerPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :index_without_quick_jump_equipment, :index
          alias_method :index, :index_with_quick_jump_equipment
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def index_with_quick_jump_equipment
          # Adds an easy way to jump to an equipment view based on id
          if User.current.allowed_to?(:view_equipment_assets, nil, {:global => true})
            tmp_question = params[:q] || ""
            tmp_question.strip!
            if tmp_question.match(/^e(quip|quipment)?\s*(\d+)$/i) && EquipmentAsset.find_by_id($2.to_i)
              redirect_to :controller => "equipment_assets", :action => "show", :id => $2
              return
            elsif tmp_question.match(/^c(i|heck[_\s]*in)?\s*(\d+)$/i) && EquipmentAsset.find_by_id($2.to_i)
              redirect_to :controller => "asset_check_ins", :action => "new", :equipment_asset_id => $2
              return
            end
          end

          # Continue on unscathed
          index_without_quick_jump_equipment
        end
      end
    end
  end
end
