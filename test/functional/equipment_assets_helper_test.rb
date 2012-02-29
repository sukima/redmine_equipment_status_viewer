# Redmine Equipment Status Viewer - An equipment manager plugin
# Copyright (C) 2010-2011  Devin Weaver
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.dirname(__FILE__) + '/../test_helper.rb'
require 'equipment_assets_helper'

class EquipmentAssetsHelperTest < ActionController::TestCase
  fixtures :equipment_assets, :asset_check_ins

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper
  include ActionController::UrlWriter
  include ApplicationHelper
  include EquipmentAssetsHelper

  default_url_options[:host] = "test.host"

  context "split_path" do
    context "for http url" do
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
    context "for https url" do
      setup do
        @path = split_path("https://test.host/path/id")
      end
      should "return a proper hash" do
        assert_not_nil @path[:host]
        assert_not_nil @path[:path]
      end
      should "remove leading slash" do
        assert @path[:path][1] != '/'
      end
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

  # context "ci_url" do
    # setup do
      # @asset = EquipmentAsset.find(1)
    # end
    # context "without bit.ly option" do
      # setup do
        # assert @url = ci_url(@asset)
      # end
      # should "have well formed url" do
        # assert_match 'http://', @url
        # assert_match 'check_in', @url
      # end
      # should_not "have bit.ly in the url" do
        # assert_match 'bit.ly', @url
      # end
    # end
    # context "with bit.ly option" do
      # setup do
        # assert @url = ci_url(@asset, :bitly => true)
      # end
      # should "have well formed url" do
        # assert_match 'http://', @url
        # assert_match 'check_in', @url
      # end
      # should "have bit.ly in the url" do
        # assert_match 'bit.ly', @url
      # end
    # end
  # end

  context "name_and_type" do
    setup do
      @asset = EquipmentAsset.new(
        :asset_type => "test_type",
        :name => "test"
      )
    end
    should "return a string" do
      assert name_and_type(@asset).kind_of? String
    end
  end

  context "simple_date" do
    should "return a string" do
      assert simple_date(Time.now).kind_of? String
    end
  end

  context "print_check_in" do
    setup do
      @check_in = AssetCheckIn.new(
        :person => "test",
        :location => "foobar",
        :created_at => Time.now
      )
    end
    should "return a string" do
      assert print_check_in(@check_in).kind_of? String
      assert print_check_in(@check_in, :only => :person).kind_of? String
      assert print_check_in(@check_in, :except => :date).kind_of? String
      assert print_check_in(@check_in, :only => :all).kind_of? String
      assert print_check_in(@check_in, :except => :none).kind_of? String
      assert print_check_in(@check_in, :link => :true).kind_of? String
      assert print_check_in(@check_in, :link => :false).kind_of? String
      assert print_check_in(@check_in, :except => :none, :link => true).kind_of? String
      assert print_check_in(@check_in, :except => :none, :fuzzy_date => false).kind_of? String
    end
  end

  context "assets_grouped_by" do
    should "return a string" do
      assert assets_grouped_by().kind_of? String
    end
  end

  context "attribute_is_grouped?" do
    should "return a boolean" do
      assert attribute_is_grouped?('asset_type')
      assert attribute_is_grouped?(:asset_type)
    end
  end

  context "asset_group" do
    setup do
      @asset = EquipmentAsset.new(:asset_type => 'foobar')
    end
    should "return a string" do
      assert asset_group(@asset).kind_of? String
    end
    should "match accessor value" do
      assert_equal 'foobar', asset_group(@asset)
    end
  end

  context "new_asset_group?" do
    setup do
      @asset = EquipmentAsset.new(:asset_type => 'foobar')
    end
    should "return false when not new" do
      assert !new_asset_group?(@asset, 'foobar')
    end
    should "return true when new" do
      assert new_asset_group?(@asset, 'barfoo')
    end
  end
end
