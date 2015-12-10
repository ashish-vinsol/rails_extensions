class RemoveReferenceFromCategories < ActiveRecord::Migration
  def change
    remove_reference(:categories, :product, index: true, foreign_key: true)
  end
end
