class AddAwardNameToAnalyticsEvent < ActiveRecord::Migration
  def change
    add_column :analytics_events, :award_name, :string
  end
end
