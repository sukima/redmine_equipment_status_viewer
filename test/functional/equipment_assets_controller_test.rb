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
end
