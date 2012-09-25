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
                :description => Proc.new {|o| "#{I18n.t(:label_equipment_asset_type)}: #{o.asset_type}, #{I18n.t(:field_serial_number)}: #{o.serial_number} #{o.comment}"},
                :type => "project" # Fake an existing type for pretty icon

  validates_presence_of :name

  validates_uniqueness_of :serial_number, :allow_nil => true, :allow_blank => true

  # Not a perfect solution but good enough.
  validates_format_of :resource_url, :allow_nil => true, :allow_blank => true,
    :with => URI::regexp(%w(http https file)), :message => 'does not appear to be valid'

  # Rails 3 uses scope not named_scope per
  # http://stackoverflow.com/questions/4025010/convert-named-scope-for-rails-3#4025360
  scope :visible, lambda {|*args| { :conditions => EquipmentAsset.allowed_to_condition(args.first || User.current) } }

  # Returns true if the query is visible to +user+ or the current user.
  def visible?(user=User.current)
    EquipmentAsset.allowed?(user)
  end

  def location
    if asset_check_ins && asset_check_ins.last
      asset_check_ins.last.location
    else
      I18n.t(:unknown)
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
      I18n.t(:unknown)
    end
  end

  def project
    # Hack to placate the use of project in search view
    I18n.t(:field_equipment_asset)
  end

  def project_id
    # Hack to placate the use of project_id in search view
    nil
  end

  def self.search(tokens, projects=nil, options={})
    # When a search is done while in a project view it only searches for items
    # associated to that project. Since equipment_assets are not associated to
    # projects we override the default search method to do our own search only
    # if no projects are assigned (ie from the index page)
    if !projects.nil?
      # no results
      return [[], 0]
    end

    # EquipmentAsset is not associated with a project. Always nil.
    super(tokens, nil, options)
  end

  def self.allowed_to_condition(user)
    # Return requires a valid SQL expression. Typically used to test a column
    # value in a normal WHERE clase. But since we are testing visiblity we need
    # an IF / THEN that will return rows or an empty set (no rows).
    EquipmentAsset.allowed?(user) ? "1 = 1" : "1 = 0"
  end

  private
  def self.allowed?(user)
    user.allowed_to?(:view_equipment_assets, nil, {:global => true})
  end
end
