class UserMailer < ActionMailer::Base
  default from: "shareyourthoughts@gmail.com"

  def welcome_email(userhash)
    @user = userhash
    @url = root_url
    mail(to: @user.email, subject: 'Welcome to Shareyourthoughts')
  end

  def email_confirmation_email(userhash)
    @user = userhash
    @url = root_url
    mail(to: @user.email, subject: 'Shareyourthoughts email confirmation')
  end
end
