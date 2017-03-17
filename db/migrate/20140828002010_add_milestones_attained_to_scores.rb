class AddMilestonesAttainedToScores < ActiveRecord::Migration
  def change
    add_column :scores, :milestones_attained, :string
  end
end
