class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.string :images
      t.string :body
      t.string :date

      t.timestamps
    end
  end
end
