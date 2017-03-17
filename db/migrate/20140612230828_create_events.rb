class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.guid      :app_id,      :null => false
      t.string    :name,        :null => false
      t.timestamp :starts_at
      t.timestamp :ends_at
      t.string    :min_app_version
      t.string    :min_asset_tag

      t.timestamps
    end
  end
end
