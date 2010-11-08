require File.dirname(__FILE__) + '/../test_helper'

class EquipmentAssetTest < ActiveSupport::TestCase
  fixtures :equipment_assets
  should have_many :last_seens
  should validate_presence_of :name

  context "location method" do
    should "return false if no last_seen found" do
      setup do
        assert @asset = EquipmentAsset(:two)
      end
      assert !@assert.location
    end
  end
end
