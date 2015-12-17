class Product < ActiveRecord::Base
  # FIXME_SG: write comments

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

  # FIXME_SG: read query
  validates :permalink, uniqueness: true, format: {
    with: /\A(\w+-){2,}\w+\Z/,
    message: 'wrong format'
  }
  validates :description, length: {
    within: 5..10,
    tokenizer: lambda { |str| str.chomp.split(" ") }
  }
  # FIXME_SG: we also have presence above
  validates :category_id, presence: true
  after_save :update_products_count

  scope :enabled, -> { where(enabled: true) }

  #FIX: move to public. also see how to define private class methods
  def self.latest
    Product.order(:updated_at).last
  end

  private

  def set_title_if_blank
    #FIXME_SG: we do not have to write self if only reading
    self.title = 'abc' if self.title.blank?
  end

  def set_discount_price
    #FIXME_SG: we do not have to write self if only reading
    self.discount_price = self.price if self.discount_price.blank?
  end

  #FIXME_SG: FIX: BUG: this will not update count in previous category and subcategories.
  def update_products_count
    Category.find(category_id_was).count -= 1 if category_id_was
    category.update_columns(count: 1 + category.subcategories.pluck('count').sum)
  end

  # FIXME_SG: fix_it
  def self.products_json_content
    #FIXME_SG: spacing
    Product.joins(:category).pluck('title','name')
    #FIX: rename column to #products_count
  end

end
