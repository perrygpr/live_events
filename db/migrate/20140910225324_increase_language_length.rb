class IncreaseLanguageLength < ActiveRecord::Migration
  def change
    change_column :devices, :language_code, :string, :limit => 10
    change_column :devices, :country, :string, :limit => 10
    change_column :devices, :os_version, :string, :limit => 25
  end
end
