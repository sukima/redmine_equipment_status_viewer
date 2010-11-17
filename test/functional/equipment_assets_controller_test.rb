require File.dirname(__FILE__) + '/../test_helper'
require 'equipmentasset_assets_controller'

# Re-raise errors caught by the controller.
class EquipmentAssetsController; def rescue_action(e) raise e end; end

class EquipmentAssetsControllerTest < Test::Unit::TestCase
  def setup
    @controller           = EquipmentAssetsController.new
    @request              = ActionController::TestRequest.new
    @response             = ActionController::TestResponse.new
    #@equipment_asset = EquipmentAssets :one
  end

  should_be_restful do |resource|
    resource.formats = [:html]
  end

  context "get :index" do
    setup do
      get :index
    end
    should assign_to(:lastseen_list)
  end

end

# class EquipmentStatusControllerTest < ActionController::TestCase
#   fixtures :equipment_assets

#   context "get index" do
#     setup do
#       get :index
#     end

#     should assign_to(:equipment_assests).with_kind_of(Array)
#     should respond_with :success
#     should render_with_layout
#     should render_template :index
#     should_not set_the_flash
#   end

#   context "get new" do
#     setup do
#       get :new
#     end

#     should assign_to(:equipment_asset).with_kind_of(EquipmentAsset)
#     should respond_with :success
#     should render_with_layout
#     should render_template :new
#     should_not set_the_flash
#   end

#   # context "post create" do
#   #   setup do
#   #     post :create 
#   #   end
#   # end
# end
