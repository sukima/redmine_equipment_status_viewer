require File.dirname(__FILE__) + '/../test_helper'

class AssetCheckInTest < ActiveSupport::TestCase
  fixtures :equipment_assets, :asset_check_ins
  should_belong_to :equipment_asset
  should_validate_presence_of :location, :person, :equipment_asset_id
end
