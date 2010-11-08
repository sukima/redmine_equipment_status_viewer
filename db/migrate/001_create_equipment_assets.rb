class CreateEquipmentAssets < ActiveRecord::Migration
  def self.up
    create_table :equipment_assets do |t|
      t.column :name, :string
      t.column :inservice, :boolean
      t.column :type, :string
      t.column :serial_number, :string
    end
  end

  def self.down
    drop_table :equipment_assets
  end
end
