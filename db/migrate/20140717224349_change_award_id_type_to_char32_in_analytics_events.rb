class ChangeAwardIdTypeToChar32InAnalyticsEvents < ActiveRecord::Migration
  def change
    change_column :analytics_events, :award_id, "char(32)"
  end
end
