# Equipment Status Viewer

Equipment Status Viewer is a Redmine plugin that tracks the location of
equipment. It uses a check in system to track where each item is. It can also
print out a QRCode label that your iPhone or Andriod phone can snap and check
in quickly.  Simply updated it to support redmine 3.2x

Licensed under GPL v3 or earlier.


1.- Install Redmine (http://www.redmine.org/wiki/1/RedmineInstall)
2.- Get the plugin and install
  $> cd #{RAILS_ROOT}/plugins
  $> git clone https://github.com/MicroHealthLLC/redmine_equipment_status_viewer/
  $> cd ..
  $> rake redmine:plugins:migrate RAILS_ENV=production
3.- Start your server and enjoy! :D
