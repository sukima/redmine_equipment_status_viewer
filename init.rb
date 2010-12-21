require 'redmine'

Redmine::Plugin.register :redmine_equipment_status_viewer do
  name 'Redmine Equipment Status Viewer plugin'
  author 'Devin Weaver'
  description 'Allows admins to make a list of equipment and track if they are inservice or not'
  version '0.1.2'
  url 'http://github.com/sukima/RedmineEquipmentStatusPlugin'
  author_url 'http://github.com/sukima'

  menu :application_menu, :equipment_status_viewer,
    { :controller => 'equipment_assets', :action => 'index' },
    :caption => 'Equipment'
end
