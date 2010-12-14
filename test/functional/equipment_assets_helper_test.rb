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

  context "name_and_type" do
    setup do
      @asset_mock = Class.new
      def @asset_mock.asset_type
        "test_type"
      end
      def @asset_mock.name
        "test"
      end
    end
    should "return a string" do
      assert name_and_type(@asset_mock).kind_of? String
    end
  end

  context "simple_date" do
    should "return a string" do
      assert simple_date(Time.now).kind_of? String
    end
  end
end
