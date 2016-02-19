class Company < ActiveRecord::Base
  include PermalinkFor

  mount_uploader :logo_image, CompanyLogoImageUploader
  permalink_for :title, as: :slug

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
    self.published = true
    save!
  end

  def cancel_publication!
    self.published = false
    save!
  end

  def admin?(user)
    return true if founder == user
    member = membership_for(user)
    member && member.admin?
  end
  # see https://coderwall.com/p/heed_q/rails-routing-and-namespaced-models
  def self.use_relative_model_naming?
    true
  end
end
