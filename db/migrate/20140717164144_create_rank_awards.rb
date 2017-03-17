class CreateRankAwards < ActiveRecord::Migration
  def change
    create_table :rank_awards do |t|
      t.guid     :event_id,    :null => false
      t.integer  :start_rank,  :null => false
      t.integer  :end_rank,    :null => false
      t.string   :awards,      :null => false

      t.timestamps
    end

    add_index :rank_awards, [:event_id, :start_rank], :unique => true
    add_index :rank_awards, [:event_id, :end_rank], :unique => true
    add_index :rank_awards, :event_id
  end
end
