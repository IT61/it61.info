class Company::Member < ActiveRecord::Base
  bitmask :roles, as: [:employer, :admin]

  belongs_to :user, required: true
  belongs_to :company, required: true

  validates :user_id, uniqueness: { scope: :company_id }

  values_for_roles.each { |role| scope role, -> { with_roles role } }
  alias_method :has_role?, :roles?

  # Методы для быстрой проверки наличия роли у пользователя.
  values_for_roles.each do |role|
    define_method "#{role}?" do
      has_role? role
    end
  end
end
