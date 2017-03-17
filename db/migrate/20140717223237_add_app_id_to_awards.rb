class AddAppIdToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :app_id, "char(32)", :null => false
    remove_index :awards, [:player_id, :event_id, :name]
    add_index :awards, [:app_id, :player_id]
  end
end
