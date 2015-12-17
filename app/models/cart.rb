class Cart < ActiveRecord::Base

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  scope :enabled, -> { where(enabled: true) }
  # FIXME: use scope for enable products.

  def add_product(product_id)
    #FIX: try finding and initializing in one line.
    current_item = line_items.find_by(product_id: product_id)
    current_item ? (current_item.quantity += 1) : (current_item = line_items.build(product_id: product_id))
    current_item
  end
  def total_price
    line_items.inject(0) { |a, b| a += b.total_price }
  end

end
