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

module IphoneHelper
  def is_iphone_request?(request)
    # This is a kludge hack. Idea from:
    # http://www.ibm.com/developerworks/opensource/library/os-eclipse-iphoneruby1/
    # Modified due to home screen problem:
    # http://kosmaczewski.net/2009/10/30/http-headers-web-apps-and-mobile-safari/
    request.user_agent =~ /(AppleWebKit\/.+Mobile)/
  end
end
