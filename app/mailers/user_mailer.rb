class UserMailer < ActionMailer::Base
  def notice_about_request(user, company)
    @user = user
    @company = company

    subj = I18n.t('user_mailer.notice_about_request.subject', company: @company.title)
    mail(to: user.email, subject: subj)
  end

  def notice_about_accept(user, company)
    @user = user
    @company = company

    subj = I18n.t('user_mailer.notice_about_accept.subject', company: @company.title)
    mail(to: user.email, subject: subj)
  end
    
  def notice_about_delete(user, company)
    @user = user
    @company = company

    subj = I18n.t('user_mailer.notice_about_delete.subject', company: @company.title)
    mail(to: user.email, subject: subj)
  end

end
