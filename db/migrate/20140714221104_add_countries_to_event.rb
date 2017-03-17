class AddCountriesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :countries, :text
  end
end
