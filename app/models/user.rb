class User < ActiveRecord::Base

  has_secure_password
  has_many :orders
  has_many :line_items, through: :orders
  has_one :address

  validates :name, presence: true, uniqueness: true
  validates :email, format: {
    with: /\A([a-z0-9_\.-]{3,})@([a-z]{5,})\.([a-z \.]{2,5})\Z/,
    message: 'wrong email format'
  }
  validates :email, uniqueness: true

  before_destroy :ensure_an_admin_remains
  before_update :prevent_admin_update
  after_create :send_mail

  private
    def ensure_an_admin_remains
      if self.role == 'admin'
        raise "Can't delete admin"
      end
    end

    def prevent_admin_update
      if self.role == 'admin'
        false
      end
    end

    def send_mail
      UserNotifier.create_notification.deliver
    end

end
