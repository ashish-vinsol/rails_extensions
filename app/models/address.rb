class Address < ActiveRecord::Base
  belongs_to :user

  validates :state, :city, :pincode, :country,  presence: true
  # FIXME_SG: in on line with user presence

end
