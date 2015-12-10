class Category < ActiveRecord::Base
  has_many :products, dependent: :destroy
  has_many :subcategories, class_name: "Category", foreign_key: "parent_category_id"
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_category_id"

  before_destroy :ensure_not_containing_products

  validates :name, presence: true
  validates :name, uniqueness: { allow_blank: true, scope: :parent_category_id }
  validates_with CategoryValidator

  private

  def ensure_not_containing_products
    if products.empty? && subcategories.each { |subcategory| subcategory.products.empty? }
      subcategories.destroy_all
    else
      errors.add(:base, 'Products present')
      return false
    end
  end

end
