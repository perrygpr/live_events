class EventPlatforms < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.boolean :platform_ios, :default => false
      t.boolean :platform_google, :default => false
      t.boolean :platform_amazon, :default => false
    end
  end
end
