class AdminMailer < BaseMailer
  
  def request_to_membership(user, company, member)
    @user    = user
    @company = company
    @member  = member

    subj = I18n.t('admin_mailer.request_to_membership.subject', company: @company.title)
    mail(to: user.email, subject: subj)
  end

  def new_company_user(user, new_user)
    @user     = user
    @new_user = new_user

    subj = I18n.t('admin_mailer.new_company_user.subject', user: @new_user.full_name)
    mail(to: user.email, subject: subj)
  end

  def delete_user_from_company(user, deleted_user)
    @user         = user
    @deleted_user = deleted_user

    subj = I18n.t('admin_mailer.delete_user_from_company.subject', user: @deleted_user.full_name)
    mail(to: user.email, subject: subj)    
  end

  def changing_user_permissions(user, member)
    @user   = user
    @member = member

    subj = I18n.t('admin_mailer.changing_user_permissions.subject', user: @member.full_name)
    mail(to: user.email, subject: subj)
  end


end
