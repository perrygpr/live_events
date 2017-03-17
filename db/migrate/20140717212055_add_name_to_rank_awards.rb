class AddNameToRankAwards < ActiveRecord::Migration
  def change
    add_column :rank_awards, :name, :string
    add_index :rank_awards, [:event_id, :name], :unique => true
  end
end
