class AdminMailer < BaseMailer
  
  def request_to_membership(user, company, member)
    @user    = user
    @company = company
    @member  = member

    subj = I18n.t('admin_mailer.request_to_membership.subject', company: @company.title)
    mail(to: user.email, subject: subj)
  end

  def adding_user(user, new_user)
    @user     = user
    @new_user = new_user

    subj = I18n.t('admin_mailer.adding_user.subject', user: @new_user.full_name)
    mail(to: user.email, subject: subj)
  end

  def deleting_user(user, deleted_user)
    @user         = user
    @deleted_user = deleted_user

    subj = I18n.t('admin_mailer.deleting_user.subject', user: @deleted_user.full_name)
    mail(to: user.email, subject: subj)    
  end

  def changing_user_permissions(user, member)
    @user   = user
    @member = member

    subj = I18n.t('admin_mailer.changing_user_permissions.subject', user: @member.full_name)
    mail(to: user.email, subject: subj)
  end


end
