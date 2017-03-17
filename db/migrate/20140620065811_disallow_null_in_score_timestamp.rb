class DisallowNullInScoreTimestamp < ActiveRecord::Migration
  def change
    change_column_null(:scores, :timestamp, false)
  end
end
