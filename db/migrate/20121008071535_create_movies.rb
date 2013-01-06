class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, presence: true
      t.string :key, presence: true
      t.string :site, presence: true
      t.string :description
      t.string :thumbnail_url
      t.timestamp :first_retrieve
      t.string :length, presence: true
      t.integer :movie_size
      t.integer :view_counter
      t.boolean :embeddable

      t.timestamps
    end
  end
end
