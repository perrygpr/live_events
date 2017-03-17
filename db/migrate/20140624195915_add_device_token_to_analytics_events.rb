class AddDeviceTokenToAnalyticsEvents < ActiveRecord::Migration
  def change
    add_column :analytics_events, :device_token_id, "char(32)"
  end
end
