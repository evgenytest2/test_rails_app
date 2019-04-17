class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :picture_url
      t.decimal :price
      t.string :source_url

      t.timestamps
    end
  end
end
