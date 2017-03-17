class CreatePfids < ActiveRecord::Migration
  def change
    create_table :pfids do |t|
      t.string :last_locale
      t.string :displayname
      t.string :hashed_password
      t.string :email
      t.datetime :last_connection
      t.string :last_guid
      t.datetime :last_device_reset

      t.timestamps
    end
  end
end
