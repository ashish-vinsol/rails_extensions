class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true, foreign_key: true
      t.string :state
      t.string :city
      t.string :country
      t.integer :pincode
      t.timestamps null: false
    end
  end
end
