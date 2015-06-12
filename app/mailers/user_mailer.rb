class UserMailer < ActionMailer::Base
  default from: ::MoVember.config['mail']['from_address']

  def notify_payment(user, url)
    @user = user
    @url = url

    mail(
      :to => @user.email,
      :subject => "Your donation to mISTache has been registered"
    )
  end
end
