# Redmine Equipment Status Viewer - An equipment manager plugin
# Copyright (C) 2012  Devin Weaver
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../test_helper', __FILE__)

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

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
