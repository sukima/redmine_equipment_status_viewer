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

class EquipmentAssetsController < ApplicationController
  unloadable
  include RedmineEquipmentStatusViewer::ControllerHelper

  helper :equipment_assets, :asset_check_ins
  include EquipmentAssetsHelper

  #before_filter :require_login, :except => [ :index, :show, :print ]
  before_filter :authorize_global, :save_mobile_param

  def index
    # location is not a SQL query-able variable. Make a concession here.
    if assets_grouped_by != 'none' && assets_grouped_by == 'location'
      # location is a calculated attribute. Find can not sort this correctly.
      # Make our own sort.
      @equipment_assets = EquipmentAsset.find(:all, :order => "name asc").
        sort!{|t1,t2| t1.location <=> t2.location}
      @groups = AssetCheckIn.count(:all, :group => 'location')
    elsif assets_grouped_by != 'none'
      @equipment_assets = EquipmentAsset.find(:all, :order => "#{assets_grouped_by}, name asc")
      @groups = EquipmentAsset.count(:all, :group => "#{assets_grouped_by}")
    else
      @equipment_assets = EquipmentAsset.find(:all, :order => "name asc")
      @groups = { }
    end
    @asset_check_ins = AssetCheckIn.find(:all, :order => "id desc", :limit => 20)
  end

  def show
    @equipment_asset = EquipmentAsset.find(params[:id])
  
    respond_to do |wants|
      wants.html # show.html.erb
      wants.xml  { render :xml => @equipment_asset }
    end
  end

  def edit
    @equipment_asset = EquipmentAsset.find(params[:id])
    @asset_types = EquipmentAsset.find(:all).map(&:asset_type).uniq if mobile_device?
    render "edit_iphone", :layout => 'equipment_status_viewer_mobile' if mobile_device?
  end

  def new
    @equipment_asset = EquipmentAsset.new
  
    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @equipment_asset }
    end
  end

  def create
    @equipment_asset = EquipmentAsset.new(params[:equipment_asset])
  
    respond_to do |wants|
      if @equipment_asset.save
        flash[:notice] = t(:equipment_asset_created)
        wants.html { redirect_to(@equipment_asset) }
        wants.xml  { render :xml => @equipment_asset, :status => :created, :location => @equipment_asset }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @equipment_asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @equipment_asset = EquipmentAsset.find(params[:id])
  
    respond_to do |wants|
      if @equipment_asset.update_attributes(params[:equipment_asset])
        flash[:notice] = t(:equipment_asset_updated)
        wants.html do
          if mobile_device?
            redirect_to equipment_asset_check_in_path(@equipment_asset)
          else
            redirect_to(@equipment_asset)
          end
        end
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @equipment_asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @equipment_asset = EquipmentAsset.find(params[:id])
    @equipment_asset.destroy
  
    respond_to do |wants|
      wants.html { redirect_to(equipment_assets_url) }
      wants.xml  { head :ok }
    end
  end

  # def check_in
  #   @equipment_asset = EquipmentAsset.find(params[:id])

  #   if request.post?
  #     @last_seen = LastSeen.new(
  #       :person => params[:last_seen_person],
  #       :location => params[:last_seen_location])
  #     @last_seen.equipment_asset = @equipment_asset
  #     if @last_seen.save && @equipment_asset.update_attributes(params[:equipment_asset])
  #       flash[:notice] = 'Saved.'
  #       redirect_to(@equipment_asset)
  #     end
  #   else
  #     @last_seen = LastSeen.new
  #     @last_seen.equipment_asset = @equipment_asset
  #   end
  # end

  def print
    if request.put?
      @equipment_assets = EquipmentAsset.find(params[:asset_ids])
      render "printm", :layout => false
    elsif params[:id] == "all"
      @equipment_assets = EquipmentAsset.find(:all)
      render "printm", :layout => false
    else
      @equipment_asset = EquipmentAsset.find(params[:id])
      render :layout => false
    end
  end

  # private
  # def getQRCode(data, test = false)
    # # QRCode seems to bork with a nil pointer. Hunch is that the data byte
    # # count is odd not even. Add padding to compensate.
    # # See bug report: https://github.com/whomwah/rqrcode/issues#issue/1
    # data += "?" if (data.length % 2 == 1)
    # size = 4 # good default to start with
    # size += 1 if data.length > 46 # Max value for size 4 using EC level :q
    # size += 1 if data.length > 60 # Max value for size 5 using EC level :q
    # size += 1 if data.length > 74 # Max value for size 6 using EC level :q
    # size += 1 if data.length > 86 # Max value for size 7 using EC level :q
    # size += 1 if data.length > 108 # Max value for size 8 using EC level :q
    # size += 1 if data.length > 130 # Max value for size 9 using EC level :q
    # # Max size is 10. After that your URL data is too big. You'll get an exception.
    # if test
      # size
    # else
      # RQRCode::QRCode.new(data, :size => size, :level => :q)
    # end
    # # TODO: shorten URL (bit.ly, tinyurl.com)
  # end
end
