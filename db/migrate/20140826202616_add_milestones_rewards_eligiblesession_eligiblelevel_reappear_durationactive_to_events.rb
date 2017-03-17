class AddMilestonesRewardsEligiblesessionEligiblelevelReappearDurationactiveToEvents < ActiveRecord::Migration
  def change
    add_column :events, :milestones, :string
    add_column :events, :rewards, :string
    add_column :events, :eligiblesession, :string
    add_column :events, :eligiblelevel, :string
    add_column :events, :reappear, :time
    add_column :events, :durationactive, :time
  end
end
