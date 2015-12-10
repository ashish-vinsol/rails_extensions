class AddDefaultValueToEnabled < ActiveRecord::Migration
  def change
    change_column_default :products, :enabled, false
  end
end
