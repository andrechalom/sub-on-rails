class ApplicationMailer < ActionMailer::Base
  default from: "sub.on.rails@gmail.com"
  layout 'mailer'

  def welcomeMail (user)
      @user = user
      if Server.instance.has_mail
          mail to: @user.email, subject: "Boas vindas!"
      end
  end
  def authMail (user)
      @user = user
      @auth_name = User.find(@user.user_id).nome
      if Server.instance.has_mail
          mail to: @user.email, subject: "Acesso autorizado!"
      end
  end
end
