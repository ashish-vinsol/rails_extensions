class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :product, index: true, foreign_key: true
      t.string :name
      t.integer :parent_category_id
      t.timestamps null: false
    end
  end
end
