class Address < ActiveRecord::Base
  belongs_to :user

  # FIXME_SG: in on line with user presence
  validates :state, presence: true
  validates :city, presence: true
  validates :pincode, presence: true
  validates :country, presence: true

end

