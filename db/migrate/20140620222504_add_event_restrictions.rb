class AddEventRestrictions < ActiveRecord::Migration
  def change
    add_column :events, :restrictions, :string
  end
end
