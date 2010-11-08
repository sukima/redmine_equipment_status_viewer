require File.dirname(__FILE__) + '/../test_helper'

class LastSeenTest < ActiveSupport::TestCase
  fixtures :last_seens, :equipment_assets
  should belong_to :equipment_asset
  should validate_presence_of :location
end
