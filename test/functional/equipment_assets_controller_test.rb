require File.dirname(__FILE__) + '/../test_helper.rb'
require 'equipment_assets_controller'

# Re-raise errors caught by the controller.
#class EquipmentAssetsController; def rescue_action(e) raise e end; end

class EquipmentAssetsControllerTest < ActionController::TestCase
  fixtures :equipment_assets, :last_seens

  def setup
    @controller = EquipmentAssetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    #User.current = nil
  end

  context "GET :index" do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :equipment_assets
    should_assign_to :lastseen_list
  end

  context "GET :new" do
    setup do
      get :new
    end
    should_respond_with :success
  end
  
  context "POST :create" do
    setup do
      @old_count = EquipmentAsset.count
      post :create, :equipment_asset => { :name => "foo" }
    end
    should "increase count by 1" do
      assert EquipmentAsset.count - @old_count == 1
    end
    should_redirect_to("equipment_asset :show") do
      equipment_asset_path(EquipmentAsset.last)
    end
  end

  context "GET :show" do
    setup do
      get :show, :id => 1
    end
    should_respond_with :success
  end

  context "GET :edit" do
    setup do
      get :edit, :id => 1
    end
    should_respond_with :success
  end
  
  context "PUT :update" do
    setup do
      put :update, :id => 1, :equipment_asset => { }
    end
    should_redirect_to("equipment_asset :show") do
      equipment_asset_path(EquipmentAsset.find(1))
    end
  end
  
  context "GET :destroy" do
    setup do
      @old_count = EquipmentAsset.count
      delete :destroy, :id => 1
    end
    should "decrease count by 1" do
      assert EquipmentAsset.count - @old_count == -1
    end
    should_redirect_to("equipment_assets :index") do
      equipment_assets_path
    end
  end

  context "GET :check_in" do
    setup do
      get :check_in, :id => 1
    end
    should_respond_with :success
    should_assign_to :equipment_asset
    should_assign_to :last_seen
  end

  context "POST :check_in" do
    setup do
      @old_count = LastSeen.count
      @equipment_asset = EquipmentAsset.find(1)
      post :check_in, :id => 1, :last_seen =>
        { :person => "foo", :location => "bar", :equipment_asset_id => 1 }
    end
    should_redirect_to("equipment_asset :show") do
      equipment_asset_path(@equipment_asset)
    end
    should_assign_to :equipment_asset
    should_assign_to :last_seen
    should_set_the_flash_to /saved/i
    should "increase last_seen count by 1" do
      assert LastSeen.count - @old_count == 1
    end
  end
end
