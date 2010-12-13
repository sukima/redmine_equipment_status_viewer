class CreateEquipmentAssets < ActiveRecord::Migration
  def self.up
    create_table :equipment_assets do |t|
      t.column :name, :string
      t.column :oos, :boolean, :null => false, :default => false
      t.column :asset_type, :string
      t.column :serial_number, :string
    end
  end

  def self.down
    drop_table :equipment_assets
  end
end
