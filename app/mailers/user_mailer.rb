class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: (t "mailers.users.account_activation.subject")
  end

  def password_reset
    @greeting = t "mailers.users.password_reset.greeting"
    mail to: (t "mailers.users.password_reset.to")
  end
end
