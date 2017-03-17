class EnforceUniqueAwardDefinition < ActiveRecord::Migration
  def change
    add_index :awards, [:type, :definition], :unique => true
  end
end
