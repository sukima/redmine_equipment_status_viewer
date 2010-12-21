require File.dirname(__FILE__) + '/../test_helper'
require 'equipment_asset'

class EquipmentAssetTest < ActiveSupport::TestCase
  fixtures :equipment_assets, :asset_check_ins
  should_have_many :asset_check_ins
  should_validate_presence_of :name
  should_validate_uniqueness_of :serial_number

  context "location method" do
    setup do
      assert @asset = EquipmentAsset.new
    end
    should "exist" do
      assert @asset.respond_to? :location
    end
    should "return string" do
      @asset.asset_check_ins = [ AssetCheckIn.new(:person => "foo", :location => "bar") ]
      assert @asset.location.kind_of? String
    end
    should "return string if no asset_check_ins found" do
      assert @asset.location.kind_of? String
    end
  end

  context "destroy parrent model" do
    setup do
      assert @asset = EquipmentAsset.find(1)
      assert @asset.destroy
    end
    should "destroy nested resources" do
      result = AssetCheckIn.find(:all, :conditions => { :equipment_asset_id => 1 })
      assert_equal 0, result.count, "found orphaned asset_check_ins"
    end
  end
end
