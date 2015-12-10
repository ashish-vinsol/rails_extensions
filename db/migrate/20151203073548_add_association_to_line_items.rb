class AddAssociationToLineItems < ActiveRecord::Migration
  def change
    add_reference(:line_items, :order, foreign_key: true)
  end
end
