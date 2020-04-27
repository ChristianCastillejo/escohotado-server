class RenameVideoTranslations < ActiveRecord::Migration[5.2]
  def change
    change_table :videos do |t|
      t.rename :title, :title_sp
      t.rename :description, :description_sp
    end
    add_column :videos, :title_en, :string
    add_column :videos, :description_en, :string
  end
end
