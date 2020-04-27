class AddDateToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :date, :string
  end
end
