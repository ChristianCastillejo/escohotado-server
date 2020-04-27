class RenameArticleTranslations < ActiveRecord::Migration[5.2]
  def change
    change_table :articles do |t|
      t.rename :title, :title_sp
      t.rename :body, :body_sp
      t.remove :description
    end
    add_column :articles, :title_en, :string
    add_column :articles, :body_en, :string
  end
end