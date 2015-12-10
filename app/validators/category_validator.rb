#FIXME: rename
class CategoryValidator < ActiveModel::Validator
  def validate(record)
    #FIXME: refactor
    if record.parent_category && record.parent_category.parent_category
      record.errors.add :base, 'This record is invalid'
    end
  end
end

