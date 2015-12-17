class Address < ActiveRecord::Base
  belongs_to :user

  validates :state, presence: true
  validates :city, presence: true
  validates :pincode, presence: true
  validates :country, presence: true

end

