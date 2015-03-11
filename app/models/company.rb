class Company < ActiveRecord::Base
  include PermalinkFor

  mount_uploader :logo_image, CompanyLogoImageUploader
  permalink_for :title, as: :slug

  belongs_to :founder, class_name: 'User', foreign_key: :founder_id
  has_many :company_members, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :founder_id, presence: true

  def has_member?(user)
    user && company_members.find_by(user_id: user.id)
  end

  def membership_for(user)
    company_members.find_by(user_id: user.id)
  end

  def publish!
    self.published = true
    save!
  end

  def cancel_publication!
    self.published = false
    save!
  end
end
