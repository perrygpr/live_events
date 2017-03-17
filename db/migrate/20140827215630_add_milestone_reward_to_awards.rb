class AddMilestoneRewardToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :milestone, :string
    add_column :awards, :reward, :string
  end
end
