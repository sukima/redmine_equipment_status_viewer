# Redmine Equipment Status Viewer - An equipment manager plugin
# Copyright (C) 2012  Devin Weaver
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

module RedmineEquipmentStatusViewer
  module ControllerHelper
    def is_mobile?
      request.user_agent =~ /Mobile|Blackberry|Android/
    end

    def mobile_device?
      if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        is_mobile?
      end
    end

    def save_mobile_param
      unless params[:mobile].blank?
        session[:mobile_param] = params[:mobile]
      end
    end
  end
end
