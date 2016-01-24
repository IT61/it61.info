class Company < ActiveRecord::Base
  mount_uploader :logo_image, CompanyLogoImageUploader

  belongs_to :founder, required: true, class_name: 'User', foreign_key: :founder_id
  # Сотрудники компании
  has_many :members, dependent: :destroy
  has_many :membership_requests,
    class_name: 'Company::MembershipRequest',
    foreign_key: :company_id,
    dependent: :destroy

  validates :title, presence: true, uniqueness: true

  scope :default_ordered, -> { order(:title) }

  def has_member?(user)
    user && membership_for(user).present?
  end

  def has_request?(user)
    user && request_for(user).present?
  end

  def membership_for(user)
    members.find_by(user_id: user.id)
  end

  def request_for(user)
    membership_requests.find_by(user_id: user.id)
  end

  def publish!
    self.toggle :published
    save!
  end

  def cancel_publication!
    self.toggle :published
    save!
  end

  def admin?(user)
    return true if founder == user
    member = membership_for(user)
    member && member.admin?
  end
end
