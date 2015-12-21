class PriceValidator < ActiveModel::Validator
  def validate(record)
    if record.price < record.discount_price
      record.errors.add :base, 'This record is invalid'
    end
  end
end
