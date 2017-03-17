class AddSuspiciousActivityToAnalyticsEvents < ActiveRecord::Migration
  def change
    add_column :analytics_events, :suspicious_activity, :string, :null => true
  end
end
