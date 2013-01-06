class AddUseFlgAndTagIdToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :use_flg, :boolean, null: false
    add_column :movies, :tag_id, :integer, null: false
  end
end
