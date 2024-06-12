class AddLikeCountToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :like_count, :integer, default: 0
  end
end
