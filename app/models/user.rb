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

  #FIXME_SG: naming
  before_destroy :ensure_an_admin_remains
  before_update :prevent_admin_update
  #FIX: this can also be moved to before_destroy
  #FIX: remove this
  after_create :send_mail

  private
    def ensure_an_admin_remains
      if role == 'admin' && User.where(role: :admin).size == 1
        raise "Can't delete admin"
      #FIXME_SG: ensure one admin remains
      end
    end

    def prevent_admin_update
      role == 'admin'
      #FIXME_SG: refactor in one line
      #FIX: define a scope for :admin, and check count
      #     Also study the differences b/w scopes and class methods
    #FIX: rename to prevent_admin_update
      #FIX: define a method to check if user is admin
      #FIX: use role to check admin instead of email
      end
    end

    def send_mail
      UserNotifier.create_notification.deliver_now
    end

end
