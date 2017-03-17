class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.guid :device_id,            :null => false
      t.guid :install_record_id,    :null => false
      t.column :token, "CHAR(20)",  :null => false
      t.boolean :used, :default => false

      t.timestamps
    end

    add_index :device_tokens, :token, :unique => true
    add_index :device_tokens, [:device_id, :install_record_id], :unique => true
  end
end
