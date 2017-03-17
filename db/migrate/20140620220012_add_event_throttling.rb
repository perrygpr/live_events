class AddEventThrottling < ActiveRecord::Migration
  def change
    add_column :events, :performance_throttle, :integer, default: 100
  end
end
