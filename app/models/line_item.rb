class LineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :product
  belongs_to :cart, counter_cache: true

  validates :product_id, uniqueness: { scope: :cart_id }
  #FIXME_SG presence
  #FIXME_SG check it!
  # validates :product_id, uniqueness: { scope: :cart_id }

  def total_price
    product.price * quantity
  end

end
