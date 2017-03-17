class IncreaseSizeOfPlayerId < ActiveRecord::Migration
  def change
    change_column :analytics_events, :player_id, :string, limit: 50
    change_column :awards, :player_id, :string, limit: 50
    change_column :cheaters, :player_id, :string, limit: 50
    change_column :scores, :player_id, :string, limit: 50
  end
end
