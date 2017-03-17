class CreateAnalyticsEvent < ActiveRecord::Migration
  def change
    create_table :analytics_events do |t|
      t.guid      :device_id,   :null => false
      t.string    :type,        :null => false
      t.datetime  :timestamp,   :null => false
      t.guid      :event_id
      t.guid      :user_id,     :null => false
      t.string    :score_name
      t.integer   :score_value

      t.timestamps
    end

    add_index :analytics_events, :device_id
    add_index :analytics_events, :type
    add_index :analytics_events, :event_id
    add_index :analytics_events, [:user_id, :event_id]
  end
end
