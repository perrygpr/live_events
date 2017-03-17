class AnalyticsEventAppId < ActiveRecord::Migration
  def change
    change_table :analytics_events do |t|
      t.guid :app_id, :null => false
    end
  end
end
