class ChangeAwardsColumnToItems < ActiveRecord::Migration
  def change
    rename_column :milestone_awards, :awards, :item
    rename_column :rank_awards, :awards, :item
  end
end
