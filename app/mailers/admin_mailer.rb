class AdminMailer < BaseMailer
  
  def request_to_membership(user, company, new_user)
    @user     = user
    @company  = company
    @new_user = new_user

    subj = I18n.t('admin_mailer.request_to_membership.subject', user: @new_user.full_name, company: @company.title)
    mail(to: user.email, subject: subj)
  end

  def new_company_user(user, company, new_user)
    @user     = user
    @new_user = new_user
    @company  = company 

    subj = I18n.t('admin_mailer.new_company_user.subject', user: @new_user.full_name, company: @company.title)
    mail(to: user.email, subject: subj)
  end

  def delete_user_from_company(user, company, deleted_user)
    @user         = user
    @deleted_user = deleted_user
    @company      = company

    subj = I18n.t('admin_mailer.delete_user_from_company.subject', user: @deleted_user.full_name, company: @company.title)
    mail(to: user.email, subject: subj)    
  end

  def changing_user_permissions(user, copmany, another_user)
    @user   = user
    @another_user = another_user

    subj = I18n.t('admin_mailer.changing_user_permissions.subject', user: @another_user.full_name)
    mail(to: user.email, subject: subj)
  end


end
