class AddNotificationContentUidToEvent < ActiveRecord::Migration
  def change
    add_column :events, :notification_content_uid, :string
  end
end
