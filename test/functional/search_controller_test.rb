require File.expand_path('../../test_helper', __FILE__)
require 'search_controller'
require 'quick_jump_equipment_patch'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

# alias_method_chain is ignored in the above require
# 'quick_jump_equipment_patch' during testing.
SearchController.send(:include, QuickJumpEquipmentPatch)

# Overide any permissions needed for testing.
class User; def allowed_to?(a,b,c) return true end; end

class SearchControllerTest < ActionController::TestCase
  fixtures :equipment_assets

  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = User.new
    # User.current = nil
  end

  def test_quick_jump_to_equipment_asset
    get :index, :q => "e3"
    assert_redirected_to '/equipment_assets/3'

    get :index, :q => "E   3"
    assert_redirected_to '/equipment_assets/3'

    get :index, :q => "equip 3"
    assert_redirected_to '/equipment_assets/3'

    get :index, :q => "equipment 3"
    assert_redirected_to '/equipment_assets/3'

    # Normal search operation continues
    get :index, :q => "foobar"
    assert_response :success
    assert_template 'index'
  end

  def test_quick_jump_to_asset_check_in
    get :index, :q => "c3"
    assert_redirected_to '/equipment_assets/3/asset_check_ins/new'

    get :index, :q => "C   3"
    assert_redirected_to '/equipment_assets/3/asset_check_ins/new'

    get :index, :q => "ci3"
    assert_redirected_to '/equipment_assets/3/asset_check_ins/new'

    get :index, :q => "checkin 3"
    assert_redirected_to '/equipment_assets/3/asset_check_ins/new'

    get :index, :q => "check_in 3"
    assert_redirected_to '/equipment_assets/3/asset_check_ins/new'

    get :index, :q => "check in 3"
    assert_redirected_to '/equipment_assets/3/asset_check_ins/new'

    # Normal search operation continues
    get :index, :q => "foobar"
    assert_response :success
    assert_template 'index'
  end
end
