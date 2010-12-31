class AddCommentsToEquipmentAssets < ActiveRecord::Migration
  def self.up
    change_table :equipment_assets do |t|
      t.text :comment
    end
  end

  def self.down
    change_table :equipment_assets do |t|
      t.remove :comment
    end
  end
end

