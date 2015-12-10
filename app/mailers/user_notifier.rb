class UserNotifier < ApplicationMailer
  default from: 'Ashish <ashish@vinsol.com>'

  def created
    mail to: 'ashish@vinsol.com', subject: 'User Created'
  end

end
