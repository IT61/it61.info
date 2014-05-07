class User < ActiveRecord::Base
  authenticates_with_sorcery!

  enum role: { member: 0, admin: 1 }

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 3 }, if: 'password.present?'
  validates :password, confirmation: true, if: 'password_required?'
  validates :password_confirmation, presence: true, if: 'password_required?', on: :create

  validates :email, presence: true, if: 'email_required?'
  validates :email, uniqueness: true, if: 'email_required?'

  after_create :assign_default_role

  def login
    name || email
  end

  private

  def password_required?
    authentications.empty?
  end

  def email_required?
    authentications.empty? || name.blank?
  end

  def assign_default_role
    unless role
      self.role = :member
      save!
    end
  end
end
