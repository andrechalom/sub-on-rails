class ApplicationMailer < ActionMailer::Base
  default from: "sub.on.rails@gmail.com"
  layout 'mailer'

  def welcomeMail (user)
      @user = user
      mail to: @user.email, subject: "Boas vindas!"
  end
end
