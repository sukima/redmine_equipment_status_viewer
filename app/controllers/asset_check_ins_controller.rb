class AssetCheckInsController < ApplicationController
  unloadable
  helper :equipment_assets

  before_filter :get_equipment_asset

  def new
    @asset_check_in = @equipment_asset.asset_check_ins.new
  
    respond_to do |wants|
      wants.html # new.html.erb
      wants.xml  { render :xml => @asset_check_in }
    end
  end

  def create
    @asset_check_in = @equipment_asset.asset_check_ins.new(params[:asset_check_in])

    respond_to do |wants|
      if @asset_check_in.save && @equipment_asset.update_attributes({:oos => params[:asset_check_in][:equipment_asset_oos]})
        flash[:notice] = 'Check in was successfull.'
        wants.html { redirect_to(@equipment_asset) }
        wants.xml  { render :xml => @asset_check_in, :status => :created, :location => @equipment_asset }
      else
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @asset_check_in.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def get_equipment_asset
    @equipment_asset = EquipmentAsset.find(params[:equipment_asset_id])
  end
end
