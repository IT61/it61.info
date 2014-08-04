class Company < ActiveRecord::Base
  mount_uploader :logo_image, CompanyLogoImageUploader

  belongs_to :founder, class_name: 'User', foreign_key: :founder_id
  # Сотрудники компании
  has_many :company_members, dependent: :destroy


  validates :title, presence: true, uniqueness: true
  validates :founder_id, null: false

  scope :default_ordered, -> { order(:title) }

  def has_member?(user)
    user && company_members.find_by(user_id: user.id)
  end

  def membership_for(user)
    company_members.find_by(user_id: user.id)
  end

  def publish!
    self.toggle :published
    save!
  end

  def cancel_publication!
    self.toggle :published
    save!
  end
end
