require File.dirname(__FILE__) + '/../test_helper'
require 'equipment_asset'

class EquipmentAssetTest < ActiveSupport::TestCase
  fixtures :equipment_assets
  should_have_many :last_seens
  should_validate_presence_of :name

  context "location method" do
    setup do
      assert @asset = EquipmentAsset.new
    end
    should "respond to location" do
      assert @asset.respond_to? :location
    end
    should "return false if no last_seen found" do
      assert !@asset.location
    end
  end
end
