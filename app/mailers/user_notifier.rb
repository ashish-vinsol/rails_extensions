class UserNotifier < ApplicationMailer
  default from: 'Ashish <ashish@vinsol.com>'

  #FIX: rename to #create_notification
  def created
    mail to: 'ashish@vinsol.com', subject: 'User Created'
  end

end
