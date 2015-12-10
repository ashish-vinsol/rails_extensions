class Cart < ActiveRecord::Base

  # FIXME: use scope for enable products.
  has_many :line_items, dependent: :destroy
  has_many :products, -> { where enabled: true}, through: :line_items

  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)
    !!current_item ? (current_item.quantity += 1) : (current_item = line_items.build(product_id: product_id))
    current_item
  end
  # FIXME refactor
  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

end
