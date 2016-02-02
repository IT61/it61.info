class Company::MembershipRequest < ActiveRecord::Base
  belongs_to :user, required: true
  belongs_to :company, required: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_company, -> (company_id) { where(company_id: company_id) }
  scope :hidden, ->(hidden) { where(hidden: hidden) }

  def hide!
    self.hidden = true
    save!
  end
end
