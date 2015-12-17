class UserNotifier < ApplicationMailer
  default from: 'Ashish <ashish@vinsol.com>'

  def create_notification
    mail to: 'ashish@vinsol.com', subject: 'User Created'
  end

end
