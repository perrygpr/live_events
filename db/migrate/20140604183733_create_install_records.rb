class CreateInstallRecords < ActiveRecord::Migration
  def up
    create_table :install_records do |t|
      t.guid :device_id, :null => false
      t.guid :app_id, :null => false
      t.guid :install_id, :null => false

      t.timestamp :install_timestamp
      t.timestamp :last_timestamp
      t.string :install_version
      t.string :last_version

      t.timestamps
    end
    add_index :install_records, [:install_id, :app_id], :unique => true
    add_index :install_records, [:device_id, :app_id]
  end

  def down
    drop_table :install_records
  end
end
