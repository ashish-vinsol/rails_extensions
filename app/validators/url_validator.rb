class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless ((value =~ %r{\.(gif|jpg|png)\Z}i))
      record.errors.add(attribute, 'does not appear to be a URL')
    end
  end
end
