# Redmine Equipment Status Viewer - An equipment manager plugin
# Copyright (C) 2010-2011  Devin Weaver
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

require File.dirname(__FILE__) + '/../test_helper.rb'
require 'asset_check_ins_controller'

# Re-raise errors caught by the controller.
class AssetCheckInsController; def rescue_action(e) raise e end; end

class AssetCheckInsControllerTest < ActionController::TestCase
  fixtures :equipment_assets, :asset_check_ins

  def setup
    #@controller = AssetCheckInsController.new
    #@request    = ActionController::TestRequest.new
    #@response   = ActionController::TestResponse.new
    @user = User.generate_with_protected!(:admin => true)
    @request.session[:user_id] = @user.id
  end

  should_route :get, "/equipment_assets/1/asset_check_ins/new",
    :action => :new, :equipment_asset_id => 1
  should_route :post, "/equipment_assets/1/asset_check_ins",
    :action => :create, :equipment_asset_id => 1
  # This test will not pass. Due to redirect maybe?
  # should_route :get, "/equipment_assets/1/check_in",
  #   :action => :new, :equipment_asset_id => 1
  should_route :get, "/equipment_assets/1/asset_check_ins/loclist",
    :action => :loclist, :equipment_asset_id => 1
  should_route :get, "/ci/1", :action => :new, :equipment_asset_id => 1

  context "GET :new" do
    setup do
      get :new, :equipment_asset_id => 1
    end
    should_respond_with :success
    should_render_template :new
    should_assign_to :equipment_asset
    should_assign_to :asset_check_in
  end
  context "GET :new with iPhone request" do
    setup do
      @request.user_agent = iphone_user_agent
      get :new, :equipment_asset_id => 1, :test => true
    end
    should_render_template :new_iphone
    should_render_without_layout
    should_assign_to :equipment_asset
    should_assign_to :asset_check_in
  end

  context "GET :loclist" do
    setup do
      get :loclist, :equipment_asset_id => 1
    end
    should_respond_with :success
    should_render_template :loclist_iphone
    should_render_without_layout
    should_assign_to :equipment_asset
    should_assign_to :asset_check_in
    should_assign_to :locations
  end
  context "GET :loclist autocomplete with bad request" do
    setup do
      get :loclist, :format => 'js', :equipment_asset_id => 1
    end
    should_respond_with :bad_request
  end
  context "GET :loclist autocomplete" do
    setup do
      get :loclist, :format => 'js', :equipment_asset_id => 1, :query => 'test_query'
    end
    should_respond_with :success
    should_respond_with_content_type /javascript/
    should_assign_to :equipment_asset
    should_assign_to :asset_check_in
    should_assign_to :locations
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
    should "set cookies for the submitted values" do
      assert_equal "foo", cookies["asset_check_in_person"], "asset_check_in_person"
      assert_equal "bar", cookies["asset_check_in_location"], "asset_check_in_location"
    end
    should_set_the_flash_to /success/i
    should_redirect_to(":show") { equipment_asset_path(1) }
  end
  context "POST :create with iPhone request" do
    setup do
      @request.user_agent = iphone_user_agent
      post :create, :equipment_asset_id => 1, :asset_check_in => {
        :person => "foo",
        :location => "bar",
        :equipment_asset_oos => true
      }
    end
    should_render_template :create_iphone
    should_render_without_layout
  end

  private
  def iphone_user_agent
    "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"
  end
end
