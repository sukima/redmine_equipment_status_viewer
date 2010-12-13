class CreateAssetCheckIns < ActiveRecord::Migration
  def self.up
    create_table :asset_check_ins do |t|
      t.column :person, :string
      t.column :location, :string
      t.belongs_to :equipment_asset
      t.timestamps
    end
  end

  def self.down
    drop_table :asset_check_ins
  end
end
