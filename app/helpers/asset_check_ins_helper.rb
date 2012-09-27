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

module AssetCheckInsHelper
  def iphone_comment_script
    str = <<-EOF
      <script type="text/javascript">
        function showAssetComment() {
          document.getElementById('comment').style.display='block';
          document.getElementById('comment_menu').style.display='none';
        }
      </script>
    EOF
    str.html_safe
  end

  def iphone_comment_menu(comment)
    return "" if !comment || comment.empty?

    if comment.length > 140
      prestr = <<-EOF
        <li id="comment_menu" class="menu">
          <a id="comment_link" href="javascript:showAssetComment()"><span class="name">Show comment</span><span class="arrow"></span></a>
        </li>
        <li id="comment" class="textbox" style="display:none;">
      EOF
    else
      prestr = <<-EOF
        <li id="comment" class="textbox">
      EOF
    end
    str = <<-EOF
        <div>#{comment}</div>
      </li>
    EOF

    prestr += str
    prestr.html_safe
  end

  def iphone_additional_resource_menu(resource_url)
    return "" if !resource_url || resource_url.empty?

    str = <<-EOF
      <li id="resource_menu" class="menu">
        <a href="#{resource_url}"><span class="name">Additianal Resource</span><span class="arrow"></span></a>
      </li>
    EOF
    str.html_safe
  end

  def iphone_details_box(equipment_asset, use_header = true)
    str = "<li class=\"textbox\">"
    str += "  <span class=\"header\">#{h equipment_asset.name }</span>" if use_header
    str += <<-EOF
        <table>
          <tbody>
            <tr>
              <td><strong>Type:</strong></td>
              <td>#{h equipment_asset.asset_type }</td>
            </tr>
            <tr>
              <td><strong>Serial #:</strong></td>
              <td>#{h equipment_asset.serial_number }</td>
            </tr>
            <tr>
              <td><strong>Location:</strong></td>
              <td>#{h equipment_asset.location }</td>
            </tr>
    EOF
    if equipment_asset.oos
      str += <<-EOF
            <tr>
              <td colspan="2" style="color: red;">#{h equipment_asset.name} is <strong>out of service</strong>!</td>
            </tr>
      EOF
    end
    str += <<-EOF
          </tbody>
        </table>
      </li>
    EOF
    str.html_safe
  end
end
