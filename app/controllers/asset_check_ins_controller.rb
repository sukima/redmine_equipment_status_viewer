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

class AssetCheckInsController < ApplicationController
  unloadable
  helper :equipment_assets

  # To avoid a login prompt on the iPhone set the 'Allow equipment check ins'
  # for the non-member/anonymous roles.
  before_filter :authorize_global, :get_equipment_asset

  def new
    @asset_check_in = @equipment_asset.asset_check_ins.new
    @asset_check_in.equipment_asset_oos = @equipment_asset.oos
    @asset_check_in.person ||= cookies[:asset_check_in_person]
    @asset_check_in.location ||= cookies[:asset_check_in_location]
  
    respond_to do |wants|
      wants.html { render_with_iphone_check }
      wants.xml  { render :xml => @asset_check_in }
    end
  end

  def loclist
    @asset_check_in = @equipment_asset.asset_check_ins.new(params[:asset_check_in])
    @locations = [] #select_values("SELECT location from asset_check_ins SORT DESC");

    respond_to do |wants|
      wants.html { render_with_iphone_check :template => 'loclist' }
      #wants.js { render :json => @locations }
    end
  end

  def create
    @asset_check_in = @equipment_asset.asset_check_ins.new(params[:asset_check_in])

    respond_to do |wants|
      if @asset_check_in.save && @equipment_asset.update_attributes({:oos => @asset_check_in.equipment_asset_oos})
        flash[:notice] = t(:asset_check_in_created)
        cookies[:asset_check_in_person] = @asset_check_in.person
        cookies[:asset_check_in_location] = @asset_check_in.location
        wants.html { render_with_iphone_check :template => 'create', :redirect => true }
        wants.xml  { render :xml => @asset_check_in, :status => :created, :location => @equipment_asset }
      else
        wants.html { render_with_iphone_check :action => "new" }
        wants.xml  { render :xml => @asset_check_in.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def get_equipment_asset
    @equipment_asset = EquipmentAsset.find(params[:equipment_asset_id])
  end

  def is_iphone_request?
    # This is a kludge hack. Idea from:
    # http://www.ibm.com/developerworks/opensource/library/os-eclipse-iphoneruby1/
    # Modified due to home screen problem:
    # http://kosmaczewski.net/2009/10/30/http-headers-web-apps-and-mobile-safari/
    request.user_agent =~ /(AppleWebKit\/.+Mobile)/
  end

  def render_with_iphone_check(args = {})
    args[:redirect] || false
    args[:template] ||= "new"

    if is_iphone_request?
      render "#{args[:template]}_iphone", :layout => false
    elsif !args[:action].nil?
      render :action => args[:action]
    elsif args[:redirect]
      redirect_to(@equipment_asset)
    # else nothing to do
    end
  end
end
