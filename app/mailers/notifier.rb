class Notifier < ActionMailer::Base
  def signup_mail(user, url)
    to = user.email
    from = "zzm@alpha-it-system.com"
    subject = "用户注册激活邮件"
    date = DateTime.now
    @user = user
    @url = url
    mail(:to => to, :from => from, :subject => subject, :date => date)
  end
end
