class UserMailer < ActionMailer::Base
  default from: "shareyourthoughts@gmail.com"

  def welcome_email(userhash)
    @user = userhash
    @url = 'http://shareyourthoughts.herokuapp.com/'
    mail(to: @user.email, subject: 'Welcome to Shareyourthoughts')
  end

end
