class Product < ActiveRecord::Base
  #FIXME_SG: spacing
  #FIXME_SG: tell me the query 'product.line_items' will fire.
  has_many :line_items, dependent: :restrict_with_error
  has_many :carts, through: :line_items
  belongs_to :category
  #FIXME_SG: remove if not using
  # before_destroy :ensure_not_referenced_by_any_line_item

  #FIXME_SG: arrange them in order they will be executed.
  before_validation :check_title, :set_discount_price

  after_save :update_products_count

  validates :title, :description, :image_url, presence: true
  #FIXME_SG: spacing
  validates :price, numericality: {greater_than_or_equal_to: 0.01}, allow_blank: true
  validates_with PriceValidator
  validates :title, uniqueness: true
  #FIXME_SG: why allow_blank true?
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  #FIXME_SG: either use presence true or allow_blank acc to requirment.
  validates :permalink, uniqueness: true, format: {
    with: /\A(\w+-){2,}\w+\Z/,
    message: 'wrong format'
  }
  validates :description, length: { within: 5..10, tokenizer: lambda { |str| str.chomp.split(" ") } }

  scope :enabled, -> { where(enabled: true) }

  private
  #FIXME_SG: remove if not using
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

  #FIX: move to public. also see how to define private class methods
  def self.latest
    Product.order(:updated_at).last
  end

  #FIXME: discuss with ...
  #FIXME_SG: Naming
  def check_title
    #FIXME_SG: you can also write it like
    # => self.title = 'abc' if self.title.blank?
    self.title.blank? ? (self.title = 'abc') : nil
  end

  def set_discount_price
    #FIXME_SG: you can also write it like
    # => self.discount_price = self.price if self.discount_price.blank?
    self.discount_price.blank? ? (self.discount_price = self.price) : nil
  end

  #FIX: BUG: this will not update count in previous category and subcategories.
  def update_products_count
    #FIXME_SG: spacing
    #FIXME_SG: why are we doing Category.find(self.category_id)
    # => first we do not have to write self
    # => i think category will also return the same thing confirm.
    #FIX: rename column to #products_count
    Category.find(self.category_id).update_column(count:  Category.find(self.category_id).products.size)
  end

end
