class User < ActiveRecord::Base

  has_secure_password
  has_many :orders
  has_many :line_items, through: :orders
  validates :name, presence: true, uniqueness: true
  validates :email, format: {
    with: /\A([a-z0-9_\.-]{3,})@([a-z]{5,})\.([a-z \.]{2,5})\Z/,
    message: 'wrong email format'
  }
  validates :email, uniqueness: true

  after_destroy :ensure_an_admin_remains
  before_destroy :check_email
  before_update :check_if_admin
  after_create :send_mail

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise "Can't delete last user"
      end
    end

    def check_email
      if self.email == 'admin@depot.com'
        raise "Can't delete user"
      end
    end

    def check_if_admin
      if self.email == 'admin@depot.com'
        false
      end
    end

    def send_mail
      UserNotifier.created.deliver
    end

end
