require File.dirname(__FILE__) + '/../test_helper'

class EquipmentAssetTest < ActiveSupport::TestCase
  fixtures :equipment_assets

  # Replace this with your real tests.
  context "EquipmentAsset model" do
    setup do
      assert @asset = EquipmentAsset.new
    end

    should "not save without a title" do
      assert !@asset.save, "model saved without a title"
    end
  end
end
