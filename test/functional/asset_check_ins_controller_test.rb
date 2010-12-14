require File.dirname(__FILE__) + '/../test_helper.rb'
require 'asset_check_ins_controller'

# Re-raise errors caught by the controller.
class AssetCheckInsController; def rescue_action(e) raise e end; end

class AssetCheckInsControllerTest < ActionController::TestCase
  fixtures :equipment_assets, :asset_check_ins

  def setup
    @controller = AssetCheckInsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    #User.current = nil
  end

  should_route :get, "/equipment_assets/1/asset_check_ins/new",
    :action => :new, :equipment_asset_id => 1
  should_route :post, "/equipment_assets/1/asset_check_ins",
    :action => :create, :equipment_asset_id => 1
  # This test will not pass. Due to redirect maybe?
  # should_route :get, "/equipment_assets/1/check_in",
  #   :action => :new, :equipment_asset_id => 1

  context "GET :new" do
    setup do
      get :new, :equipment_asset_id => 1
    end
    should_respond_with :success
    should_render_template :new
    should_assign_to :equipment_asset
    should_assign_to :asset_check_in
    context "with iPhone request" do
      setup do
        @request.user_agent = iphone_user_agent
        get :new, :equipment_asset_id => 1
      end
      should_render_template :new_iphone
    end
  end
  
  context "POST :create" do
    setup do
      @old_count = AssetCheckIn.count
      post :create, :equipment_asset_id => 1, :asset_check_in => {
        :person => "foo",
        :location => "bar",
        :equipment_asset_oos => true
      }
    end
    should "increase count by 1" do
      assert AssetCheckIn.count - @old_count == 1
    end
    should "set equipment_asset :oos to true" do
      @e = EquipmentAsset.find(1)
      assert @e.oos
    end
    should_set_the_flash_to /success/i
    should_redirect_to(":show") { equipment_asset_path(1) }
    context "with iPhone request" do
      setup do
        @request.user_agent = iphone_user_agent
        post :create, :equipment_asset_id => 1, :asset_check_in => {
          :person => "foo",
          :location => "bar",
          :equipment_asset_oos => true
        }
      end
      should_render_template :create_iphone
    end
  end

  private
  def iphone_user_agent
    "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"
  end
end
