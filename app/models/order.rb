class Order < ActiveRecord::Base

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  has_many :images, through: :products
  belongs_to :user
  #FIX: move to top
  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  scope :by_date, ->(from = Date.today.midnight, to = Time.now) { where("? < created_at < ?", from, to)}

  def add_line_items_from_cart(cart)
    #FIXME_SG check this method.
    cart.line_items.each do |item|
      item.cart_id = nil
      #FIX: don't we need item.save! here?
      self.line_items << item
    end
  end

end
