class RemoveNotificationUrlFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :notification_url
  end
end
