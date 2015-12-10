class Product < ActiveRecord::Base
  has_many :line_items ,dependent: :restrict_with_error
  has_many :carts, through: :line_items
  belongs_to :category
  # before_destroy :ensure_not_referenced_by_any_line_item
  before_validation :check_title, :set_discount_price

  after_save :update_products_count

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}, allow_blank: true
  validates_with PriceValidator
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  validates :permalink, uniqueness: true, format: {
    with: /\A(\w+-){2,}\w+\Z/,
    message: 'wrong format'
  }
  validates :description, length: { within: 5..10, tokenizer: lambda { |str| str.chomp.split(" ") } }

  scope :enabled, -> { where(enabled: true) }

  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

  def self.latest
    Product.order(:updated_at).last
  end

  #FIXME: discuss with ...
  def check_title
    self.title.blank? ? (self.title = 'abc') : nil
  end

  def set_discount_price
    self.discount_price.blank? ? (self.discount_price = self.price) : nil
  end

  def update_products_count
    Category.find(self.category_id).update_column(count:  Category.find(self.category_id).products.size)
  end

end

