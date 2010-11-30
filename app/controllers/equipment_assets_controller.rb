class EquipmentAssetsController < ActionController::Base
  unloadable
  resource_controller

  index.before do
    @lastseen_list = LastSeen.find(:all, :order => "id desc", :limit => 20)
  end

  def check_in
    @equipment_asset = EquipmentAsset.find(params[:id])

    if request.post?
      @last_seen = LastSeen.new(params[:last_seen])
      if @last_seen.save
        flash[:notice] = 'Saved.'
        redirect_to(@equipment_asset)
      end
    else
      @last_seen = LastSeen.new
    end
  end

  def print
    @equipment_asset = EquipmentAsset.find(params[:id])
  end
end
