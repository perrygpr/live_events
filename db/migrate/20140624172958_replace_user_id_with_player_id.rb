class ReplaceUserIdWithPlayerId < ActiveRecord::Migration
  def change
    rename_column :analytics_events, :user_id, :player_id
    rename_column :scores, :user_id, :player_id
    rename_column :awards, :user_id, :player_id
  end
end
