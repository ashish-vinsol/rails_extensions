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

  #FIX: this can also be moved to before_destroy
  after_destroy :ensure_an_admin_remains
  #FIX: remove this
  before_destroy :check_email
  before_update :check_if_admin
  after_create :send_mail

  private
    def ensure_an_admin_remains
      #FIX: define a scope for :admin, and check count
      #     Also study the differences b/w scopes and class methods
      if User.count.zero?
        raise "Can't delete last user"
      end
    end

    def check_email
      if self.email == 'admin@depot.com'
        raise "Can't delete user"
      end
    end

    #FIX: rename to prevent_admin_update
    def check_if_admin
      #FIX: define a method to check if user is admin
      #FIX: use role to check admin instead of email
      if self.email == 'admin@depot.com'
        false
      end
    end

    def send_mail
      UserNotifier.created.deliver
    end

end
