class AddTimestampToScore < ActiveRecord::Migration
  def change
    add_column :scores, :timestamp, :datetime
  end
end
