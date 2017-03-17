class ChangeAwardNameToAwardIdInAnalyticsEvents < ActiveRecord::Migration
  def change
    rename_column :analytics_events, :award_name, :award_id
  end
end
