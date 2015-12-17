class Category < ActiveRecord::Base
  has_many :products, dependent: :destroy
  has_many :subcategories, class_name: "Category", foreign_key: "parent_category_id"
  belongs_to :parent_category, class_name: "Category", foreign_key: "parent_category_id"

  before_destroy :ensure_not_containing_products

  validates :name, presence: true
  validates :name, uniqueness: { allow_blank: true, scope: :parent_category_id }
  validates_with CategoryCreatorValidator

  private

  def ensure_not_containing_products
    if count > 0
    #FIX: we can use this logic too
    # if products_count > 0
    #   errors.add(:base, 'Products present')
    #   false
    # end
      errors.add(:base, 'Products present')
      false
    end
  end

end

