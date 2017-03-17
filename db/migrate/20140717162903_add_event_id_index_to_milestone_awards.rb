class AddEventIdIndexToMilestoneAwards < ActiveRecord::Migration
  def change
    add_index :milestone_awards, :event_id
  end
end
