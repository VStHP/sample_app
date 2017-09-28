class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: (t "mailers.users.account_activation.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: (t "mailers.users.password_reset.subject")
  end
end
