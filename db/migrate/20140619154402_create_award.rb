class CreateAward < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.guid      :user_id,     :null => false
      t.guid      :device_id,   :null => false
      t.guid      :event_id,    :null => false
      t.string    :name,        :null => false
      t.datetime  :timestamp,   :null => false

      t.timestamps
    end

    add_index :awards, [:user_id, :event_id, :name], unique: true
    add_index :awards, :event_id
    add_index :awards, :name
  end
end
