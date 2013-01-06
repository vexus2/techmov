class AddCommentCountAndMyListCountToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :comment_counter, :integer
    add_column :movies, :mylist_counter, :integer
  end
end
