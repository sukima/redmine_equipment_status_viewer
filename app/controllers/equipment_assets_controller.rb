require 'rqrcode'

class EquipmentAssetsController < ApplicationController
  unloadable

  def index
    @equipment_assets = EquipmentAsset.all
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
        flash[:notice] = 'EquipmentAsset was successfully created.'
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
        flash[:notice] = 'EquipmentAsset was successfully updated.'
        wants.html { redirect_to(@equipment_asset) }
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
    @equipment_asset = EquipmentAsset.find(params[:id])
    @qrcode = RQRCode::QRCode.new(equipment_asset_check_in_url(@equipment_asset),
                                  :size => 4, :level => :q)
  end
end
