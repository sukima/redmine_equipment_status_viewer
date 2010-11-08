class CreateLastSeens < ActiveRecord::Migration
  def self.up
    create_table :last_seens do |t|
      t.column :person, :string
      t.column :location, :string
      t.references :equipment_assets
      t.timestamps
    end
  end

  def self.down
    drop_table :last_seens
  end
end
