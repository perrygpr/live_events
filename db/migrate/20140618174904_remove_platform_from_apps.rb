class RemovePlatformFromApps < ActiveRecord::Migration
  def up
    remove_column :apps, :platform
  end

  def down
    add_column :apps, :platform, :string
  end
end
