class AddIndexToNameFieldInItemsTable < ActiveRecord::Migration[5.2]
  def change
    add_index :items, :name
  end
end
