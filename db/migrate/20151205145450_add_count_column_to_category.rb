class AddCountColumnToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :count, :integer, default: 0, null: false
  end
end
