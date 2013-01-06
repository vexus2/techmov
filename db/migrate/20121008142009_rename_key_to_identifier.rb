class RenameKeyToIdentifier < ActiveRecord::Migration
  def up
    rename_column :movies, :key, :identifier
  end

  def down
    rename_column :movies, :identifier, :key
  end
end
