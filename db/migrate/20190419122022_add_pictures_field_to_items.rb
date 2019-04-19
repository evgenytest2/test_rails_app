class AddPicturesFieldToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :pictures,  :text
  end
end
