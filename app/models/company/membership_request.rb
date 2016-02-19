class Company::MembershipRequest < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :company, required: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_company, -> (company_id) { where(company_id: company_id) }
  scope :hidden, ->(hidden) { where(hidden: hidden) }
  scope :approved, ->(approved) { where(approved: approved) }

  def approve!
    return if approved
    self.toggle! :approved
    @company_member = Company::Member.create!(company: self.company, user: self.user)
  end

  def hide!
    self.hidden = true
    save!
  end
end
