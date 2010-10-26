class CreateEquipmentAssets < ActiveRecord::Migration
  def self.up
    create_table :equipment_assets do |t|
      t.column :name, :string
      t.column :location, :string
      t.column :inservice, :boolean
    end
  end

  def self.down
    drop_table :equipment_assets
  end
end
