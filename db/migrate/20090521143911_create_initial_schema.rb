class CreateInitialSchema < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name
      t.string :country_code, :limit => 2
      t.string :region_code, :limit => 2
      t.float :longitude
      t.float :latitude
    end
    # NOTE: worldcities data contains cities those who has same name, contry and region. Can't be treated as unique key.
    # add_index :cities, [:name, :country_code, :region_code], :unique => true

    create_table :countries do |t|
      t.string :name
      t.string :country_code, :limit => 2
    end
    add_index :countries, :country_code, :unique => true

    create_table :regions do |t|
      t.string :name
      t.string :country_code, :limit => 2
      t.string :region_code, :limit => 2
    end
    add_index :regions, [:country_code, :region_code], :unique => true
  end

  def self.down
    drop_table :regions
    drop_table :contries
    drop_table :cities
  end
end
