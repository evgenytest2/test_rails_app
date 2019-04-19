class DeletePicturesFromApp < ActiveRecord::Migration[5.2]
  def change
    drop_table :pictures
    remove_column :items, :picture_url
  end
end
