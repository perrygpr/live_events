class CreateApps < ActiveRecord::Migration
  def up
    create_table :apps do |t|
      t.string :name
      t.string :platform

      t.timestamps
    end

    add_index :apps, [:name, :platform], :unique => true
  end

  def down
    drop_table :apps
  end
end
