class CreateTagsArticlesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :tags, :articles do |t|
      t.index :tag_id
      t.index :article_id
    end
  end
end
