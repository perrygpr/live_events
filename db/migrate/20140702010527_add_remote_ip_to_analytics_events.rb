class AddRemoteIpToAnalyticsEvents < ActiveRecord::Migration
  def change
    add_column :analytics_events, :remote_ip, :string
  end
end
