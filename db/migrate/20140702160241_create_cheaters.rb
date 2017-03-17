class CreateCheaters < ActiveRecord::Migration
  def change
    create_table :cheaters do |t|
      t.guid      :player_id,     :null => false
      t.string    :notes
      t.timestamps
    end
  end
end
