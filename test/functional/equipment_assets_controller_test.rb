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

  should_route :get, "/equipment_assets", :action => :index
  should_route :get, "/equipment_assets/1", :action => :show, :id => 1
  should_route :get, "/equipment_assets/new", :action => :new
  should_route :post, "/equipment_assets", :action => :create
  should_route :get, "/equipment_assets/1/edit", :action => :edit, :id => 1
  should_route :put, "/equipment_assets/1", :action => :update, :id => 1
  should_route :delete, "/equipment_assets/1", :action => :destroy, :id => 1
  should_route :get, "/equipment_assets/1/check_in", :action => :check_in, :id => 1
  should_route :post, "/equipment_assets/1/check_in", :action => :check_in, :id => 1
  should_route :get, "/equipment_assets/1/print", :action => :print, :id => 1

  context "GET :index" do
    setup do
      get :index
    end
    should_respond_with :success
    should_assign_to :equipment_assets
    should_assign_to :lastseen_list
    should_render_template :index
  end

  context "GET :new" do
    setup do
      get :new
    end
    should_respond_with :success
    should_render_template :new
  end
  
  context "POST :create" do
    setup do
      @old_count = EquipmentAsset.count
      post :create, :equipment_asset => { :name => "foo" }
    end
    should "increase count by 1" do
      assert EquipmentAsset.count - @old_count == 1
    end
    should_redirect_to(":show") { equipment_asset_path(EquipmentAsset.last) }
  end

  context "GET :show" do
    setup do
      get :show, :id => 1
    end
    should_respond_with :success
    should_render_template :show
  end

  context "GET :edit" do
    setup do
      get :edit, :id => 1
    end
    should_respond_with :success
    should_assign_to :equipment_asset
    should_render_template :edit
  end
  
  context "PUT :update" do
    setup do
      put :update, :id => 1, :equipment_asset => { }
    end
    should_redirect_to(":show") { equipment_asset_path(EquipmentAsset.find(1)) }
  end
  
  context "GET :destroy" do
    setup do
      @old_count = EquipmentAsset.count
      delete :destroy, :id => 1
    end
    should "decrease count by 1" do
      assert EquipmentAsset.count - @old_count == -1
    end
    should_redirect_to(":index") { equipment_assets_path }
  end

  context "GET :check_in" do
    setup do
      get :check_in, :id => 1
    end
    should_respond_with :success
    should_assign_to :equipment_asset
    should_assign_to :last_seen
    should_render_template :check_in
  end

  context "POST :check_in" do
    setup do
      @old_count = LastSeen.count
      @equipment_asset = EquipmentAsset.find(1)
      post :check_in, :id => 1, :last_seen =>
        { :person => "foo", :location => "bar", :equipment_asset_id => 1 }
    end
    should "increase last_seen count by 1" do
      assert LastSeen.count - @old_count == 1
    end
    should_assign_to :equipment_asset
    should_assign_to :last_seen
    should_set_the_flash_to /saved/i
    should_redirect_to(":show") { equipment_asset_path(@equipment_asset) }
  end

  context "GET :print" do
    setup do
      get :print, :id => 1
    end
    should_respond_with :success
    should_assign_to :equipment_asset
    should_render_template :print
  end
end
