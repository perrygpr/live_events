class CreateDevices < ActiveRecord::Migration
  def up
    create_table :devices do |t|
      t.string :advertising_id
      t.string :android_id
      t.string :vendor_id
      t.string :country, :limit => 2
      t.string :language_code, :limit => 2
      t.string :os, :limit => 10
      t.string :os_version, :limit => 8
      t.string :device_type

      t.timestamps
    end
    add_index :devices, :android_id, unique: true
    add_index :devices, :advertising_id, unique: true
    add_index :devices, :vendor_id, unique: true
  end

  def down
    drop_table :devices
  end
end
