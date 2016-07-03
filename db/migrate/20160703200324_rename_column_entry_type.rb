class RenameColumnEntryType < ActiveRecord::Migration
  def change
    rename_column :entries, :type, :entry_type
  end
end
