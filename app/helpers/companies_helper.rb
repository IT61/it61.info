module CompaniesHelper
  def admin_company_icon_class(company)
    if company.published?
      'fa-eye'
    else
      'fa-eye-slash'
    end
  end
end
