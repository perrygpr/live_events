class AddAuditedFlagToEvents < ActiveRecord::Migration
  def change
    add_column :events, :audited, :boolean
  end
end
