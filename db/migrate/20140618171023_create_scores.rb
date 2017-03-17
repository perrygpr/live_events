class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.guid     :event_id,  :null => false
      t.guid     :user_id,   :null => false
      t.string   :name,      :null => false
      t.integer  :score

      t.timestamps
    end

    add_index :scores, [:event_id, :name]
    add_index :scores, [:user_id, :event_id, :name], unique: true
  end
end
