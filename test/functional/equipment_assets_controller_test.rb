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
require 'equipment_assets_controller'

# Re-raise errors caught by the controller.
#class EquipmentAssetsController; def rescue_action(e) raise e end; end

class EquipmentAssetsControllerTest < ActionController::TestCase
  fixtures :equipment_assets, :asset_check_ins

  def setup
    #@controller = EquipmentAssetsController.new
    #@request    = ActionController::TestRequest.new
    #@response   = ActionController::TestResponse.new
    @user = User.generate_with_protected!(:admin => true)
    @request.session[:user_id] = @user.id
  end

  should_route :get, "/equipment_assets", :action => :index
  should_route :get, "/equipment_assets/1", :action => :show, :id => 1
  should_route :get, "/equipment_assets/new", :action => :new
  should_route :post, "/equipment_assets", :action => :create
  should_route :get, "/equipment_assets/1/edit", :action => :edit, :id => 1
  should_route :put, "/equipment_assets/1", :action => :update, :id => 1
  should_route :delete, "/equipment_assets/1", :action => :destroy, :id => 1
  should_route :get, "/equipment_assets/1/print", :action => :print, :id => 1

  %(none asset_type location).each do |test_setting|
    context "When asset_grouped_by == none" do
      setup do
        # Re-define the method to stub out the
        # Setting.plugin_redmine_equipment_status_viewer logic
        module EquipmentAssetsHelper
          def asset_grouped_by
            "#{test_setting}"
          end
        end
      end
      context "GET :index" do
        setup do
          get :index
        end
        should_respond_with :success
        should_assign_to :equipment_assets
        should_assign_to :asset_check_ins
        should_assign_to :groups
        should_render_template :index
      end
    end
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

  context "GET :print" do
    setup do
      get :print, :id => 1
    end
    should_respond_with :success
    should_assign_to :equipment_asset
    should_render_template :print
  end
end
