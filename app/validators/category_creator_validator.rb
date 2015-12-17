class CategoryCreatorValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, 'This category cant be created' if record.parent_category.try(:parent_category)
  end
end

