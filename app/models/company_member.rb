class CompanyMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :company

  validates :user_id, presence: true
  validates :company_id, presence: true
  validates :user_id, uniqueness: { scope: :company_id }
end
