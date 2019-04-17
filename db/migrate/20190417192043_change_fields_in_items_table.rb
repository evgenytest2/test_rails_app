class ChangeFieldsInItemsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :age,    :string
    add_column :items, :vendor, :string
    add_column :items, :model,  :string
  end
end
