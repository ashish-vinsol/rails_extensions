class Address < ActiveRecord::Base
  belongs_to :user

  validates :state, :city, :pincode, :country,  presence: true

end
