class AssetCheckInsController < ApplicationController
  unloadable
  helper :equipment_assets

  before_filter :get_equipment_asset

  def new
    @asset_check_in = @equipment_asset.asset_check_ins.new
    @asset_check_in.equipment_asset_oos = @equipment_asset.oos
  
    respond_to do |wants|
      wants.html { render_with_iphone_check }
      wants.xml  { render :xml => @asset_check_in }
    end
  end

  def create
    @asset_check_in = @equipment_asset.asset_check_ins.new(params[:asset_check_in])

    respond_to do |wants|
      if @asset_check_in.save && @equipment_asset.update_attributes({:oos => @asset_check_in.equipment_asset_oos})
        flash[:notice] = t(:asset_check_in_created)
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
