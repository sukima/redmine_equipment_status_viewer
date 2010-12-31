require 'redmine'

# Equipment Status Viewer requires the RQRCode plugin
begin
  require 'rqrcode' unless Object.const_defined?('QRCode')
rescue LoadError
  # rate_plugin is not installed
  raise Exception.new("ERROR: The RQRCode plugin is not installed. Please install the RQRCode plugin from http://rqrcode.rubyforge.org/index.html")
end

Redmine::Plugin.register :redmine_equipment_status_viewer do
  name 'Redmine Equipment Status Viewer plugin'
  author 'Devin Weaver'
  description 'Allows admins to make a list of equipment and track if they are inservice or not'
  version '0.2.0'
  url 'http://github.com/sukima/RedmineEquipmentStatusPlugin'
  author_url 'http://github.com/sukima'

  permission :view_equipment_assets, {:equipment_assets => [:index, :show, :print]}
  permission :manage_equipment_assets, {:equipment_assets => [:destroy, :update, :create, :edit, :new]}
  permission :allow_equipment_check_ins, {:asset_check_ins => [ :new, :create ]}

  menu :top_menu, "Equipment",
    { :controller => 'equipment_assets', :action => 'index' },
    :caption => "Equipment", :after => :projects,
    :if => Proc.new {
      User.current.allowed_to?(:view_equipment_assets, nil, :global => true)
    }
end
