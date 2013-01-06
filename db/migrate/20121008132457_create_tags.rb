class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag
      t.boolean :del_flg

      t.timestamps
    end
  end
end
