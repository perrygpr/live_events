class Addsecretkeytoapp < ActiveRecord::Migration
  def change
    add_column :apps, :secret_key, "char(32)", :null => false
  end
end
