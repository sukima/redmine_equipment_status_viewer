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

class EquipmentAsset < ActiveRecord::Base
  unloadable

  has_many :asset_check_ins, :limit => 50, :dependent => :destroy

  acts_as_searchable :columns => [:name, :serial_number, :comment], :order_column => :name
  acts_as_event :title => :name,
                :url => Proc.new {|o| {:controller => 'equipment_assets', :action => 'show', :id => o}},
                :author => Proc.new {|o| o.last_checkin_by},
                :datetime => Proc.new {|o| o.last_checkin_on},
                :description => Proc.new {|o| "#{o.asset_type}; #{I18n.t(:field_serial_number)}: #{o.serial_number}"},
                :type => I18n.t(:field_equipment_asset)

  validates_presence_of :name

  validates_uniqueness_of :serial_number, :allow_nil => true, :allow_blank => true

  # Not a perfect solution but good enough.
  validates_format_of :resource_url, :allow_nil => true, :allow_blank => true,
    :with => URI::regexp(%w(http https file)), :message => 'does not appear to be valid'

  named_scope :visible, lambda {|*args| { :conditions => EquipmentAsset.allowed_to_condition(args.first || User.current) } }

  # Returns true if the query is visible to +user+ or the current user.
  def visible?(user=User.current)
    user.allowed_to?(:view_equipment_assets, nil, {:global => true})
  end

  def location
    if asset_check_ins && asset_check_ins.last
      asset_check_ins.last.location
    else
      "Unknown"
    end
  end

  def last_checkin_on
    if asset_check_ins && asset_check_ins.last
      asset_check_ins.last.updated_at
    else
      nil
    end
  end

  def last_checkin_by
    if asset_check_ins && asset_check_ins.last
      asset_check_ins.last.person
    else
      "Unknown"
    end
  end

  def project
    # Hack to placate the use of project in search view
    ""
  end

  def self.allowed_to_condition(user)
    # This is a major SQL hack to get around the archaic search permissions
    # which rely on a project or custom SQL code.
    user.allowed_to?(:view_equipment_assets, nil, {:global => true}) ? "" : "serial_number = 'do_not_search_access_denied'"
  end
end
