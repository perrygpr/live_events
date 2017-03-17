class CreateMilestoneAwards < ActiveRecord::Migration
  def change
    create_table :milestone_awards do |t|
      t.guid     :event_id,    :null => false
      t.string   :name,        :null => false
      t.string   :score_name,  :null => false
      t.integer  :score_value, :null => false
      t.string   :awards,      :null => false

      t.timestamps
    end

    add_index :milestone_awards, [:event_id, :name], :unique => true
  end
end
