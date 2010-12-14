require File.dirname(__FILE__) + '/../test_helper.rb'
require 'equipment_assets_helper'

class EquipmentAssetsHelperTest < ActionController::TestCase
  fixtures :equipment_assets

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionController::UrlWriter
  include ApplicationHelper
  include EquipmentAssetsHelper

  default_url_options[:host] = "test.host"

  context "split_path" do
    setup do
      @path = split_path("http://test.host/path/id")
    end
    should "return a proper hash" do
      assert_not_nil @path[:host]
      assert_not_nil @path[:path]
    end
    should "remove leading slash" do
      assert @path[:path][1] != '/'
    end
  end

  context "split_check_in_url" do
    setup do
      @asset = EquipmentAsset.find(1)
      assert @html = split_check_in_url(@asset)
    end
    should "Have both host and path" do
      assert_match 'http://', @html
      assert_match 'check_in', @html
      assert_match "<br />", @html
    end
  end
end
