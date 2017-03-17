class ChangeAwardsForServerValidation < ActiveRecord::Migration
  def change
    remove_column :awards, :event_id
    remove_column :awards, :name
    remove_column :awards, :timestamp
    add_column :awards, :type, "char(32)", :null => false
    add_column :awards, :definition, "char(32)", :null => false
  end
end
