class CreateMylistDetails < ActiveRecord::Migration
  def change
    create_table :mylist_details do |t|
      t.integer :omniuser_id
      t.integer :movie_id
      t.boolean :del_flg

      t.timestamps
    end
  end
end
