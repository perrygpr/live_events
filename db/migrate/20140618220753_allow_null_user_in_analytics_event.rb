class AllowNullUserInAnalyticsEvent < ActiveRecord::Migration
  def change
    change_column_null(:analytics_events, :user_id, true)
  end
end
