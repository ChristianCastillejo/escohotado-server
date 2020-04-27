class CreateTagsVideosJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :tags, :videos do |t|
      t.index :tag_id
      t.index :video_id
    end
  end
end