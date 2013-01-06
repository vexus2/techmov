class AddDelflgToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :del_flg, :boolean, null: false
  end
end
