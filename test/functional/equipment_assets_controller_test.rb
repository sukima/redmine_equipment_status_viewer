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
    #should assign_to(:equipment_assets)
    #should assign_to(:lastseen_list)
  end

  # context "GET :new" do
  #   setup do
  #     get :new
  #   end
  #   should respond_with :success
  # end
  
  # context "POST :create" do
  #   setup do
  #     old_count = EquipmentAsset.count
  #     post :create, :equipment_asset => { }
  #   end

  #   #should_change "EquipmentAsset.count", :by => 1
  #   #should respond_with :success
  # end

  # def test_should_show_equipment_asset
  #   get :show, :id => 1
  #   assert_response :success
  # end

  # def test_should_get_edit
  #   get :edit, :id => 1
  #   assert_response :success
  # end
  
  # def test_should_update_equipment_asset
  #   put :update, :id => 1, :equipment_asset => { }
  #   assert_redirected_to equipment_asset_path(assigns(:equipment_asset))
  # end
  
  # def test_should_destroy_equipment_asset
  #   old_count = EquipmentAsset.count
  #   delete :destroy, :id => 1
  #   assert_equal old_count-1, EquipmentAsset.count
    
  #   assert_redirected_to equipment_assets_path
  # end
end
