class Product < ActiveRecord::Base
  #FIXME_SG: spacing
  #FIXME_SG: tell me the query 'product.line_items' will fire.
  has_many :line_items, dependent: :restrict_with_error
  has_many :carts, through: :line_items
  has_many :images
  belongs_to :category
  #FIXME_SG: remove if not using
  # before_destroy :ensure_not_referenced_by_any_line_item

  #FIXME_SG: arrange them in order they will be executed.

  before_validation :set_title_if_blank, :set_discount_price

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_with PriceValidator
  validates :image_url, format: {
  #FIXME_SG: spacing
  #FIXME_SG: why allow_blank true?
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }, url: true
  #FIXME_SG: either use presence true or allow_blank acc to requirment.
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

  #FIX: move to public. also see how to define private class methods
  def self.latest
    Product.order(:updated_at).last
  end
  def self.products_json_content
    Product.joins(:category).pluck('title', 'name')
  end

  private

  def set_title_if_blank
    self.title = 'abc' if self.title.blank?
  end

  def set_discount_price
    self.discount_price = self.price if self.discount_price.blank?
  #FIXME: discuss with ...
  #FIXME_SG: Naming
    #FIXME_SG: you can also write it like
    # => self.title = 'abc' if self.title.blank?

    #FIXME_SG: you can also write it like
    # => self.discount_price = self.price if self.discount_price.blank?
  end

  #FIX: BUG: this will not update count in previous category and subcategories.
  def update_products_count
    Category.find(category_id_was).count -= 1 if category_id_was
    category.update_columns(count: 1 + category.subcategories.pluck('count').sum)
  end


    #FIXME_SG: spacing
    #FIXME_SG: why are we doing Category.find(self.category_id)
    # => first we do not have to write self
    # => i think category will also return the same thing confirm.
    #FIX: rename column to #products_count

end
