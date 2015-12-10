class Order < ActiveRecord::Base

  has_many :line_items, dependent: :destroy
  belongs_to :user
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  scope :by_date, ->(from = Date.today.midnight, to = Time.now) { where("? < created_at < ?", from, to)}

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

end
