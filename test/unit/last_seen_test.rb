require File.dirname(__FILE__) + '/../test_helper'

class LastSeenTest < ActiveSupport::TestCase
  fixtures :last_seens, :equipment_assets
  should_belong_to :equipment_asset
  should_validate_presence_of :location, :person, :equipment_asset_id
end
