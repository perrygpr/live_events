class EventNotificationUrl < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :notification_url, :default => ""
    end
  end
end
