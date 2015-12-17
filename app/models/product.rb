class Product < ActiveRecord::Base
  has_many :line_items, dependent: :restrict_with_error
  has_many :carts, through: :line_items
  has_many :images
  belongs_to :category

  before_validation :set_title_if_blank, :set_discount_price

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_with PriceValidator
  validates :image_url, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  validates :permalink, uniqueness: true, format: {
    with: /\A(\w+-){2,}\w+\Z/,
    message: 'wrong format'
  }
  validates :description, length: {
    within: 5..10,
    tokenizer: lambda { |str| str.chomp.split(" ") }
  }
  validates :category_id, presence: true
  after_save :update_products_count

  scope :enabled, -> { where(enabled: true) }


  def self.latest
    Product.order(:updated_at).last
  end

  private

  def set_title_if_blank
    self.title = 'abc' if self.title.blank?
  end

  def set_discount_price
    self.discount_price = self.price if self.discount_price.blank?
  end

  def update_products_count
    Category.find(category_id_was).count -= 1 if category_id_was
    category.update_columns(count: 1 + category.subcategories.pluck('count').sum)
  end

  def self.products_json_content
    Product.joins(:category).pluck('title','name')
  end

end

