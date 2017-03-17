class SetDefaultAuditedFalse < ActiveRecord::Migration
  def change
    change_column :events, :audited, :bool, :default => false
  end
end
