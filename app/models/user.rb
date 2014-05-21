class User < ActiveRecord::Base
  mount_uploader :avatar_image, UserAvatarUploader

  authenticates_with_sorcery!

  enum role: { member: 0, admin: 1 }

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :owner_of_events, class_name: 'Event', foreign_key: 'organizer_id'
  has_many :event_participations
  has_many :member_in_events, class_name: 'Event', through: :event_participations, source: :event

  validates :password, length: { minimum: 3 }, if: 'password.present?'
  validates :password, confirmation: true, if: 'password_required?'
  validates :password_confirmation, presence: true, if: 'password_required?', on: :create

  validates :email, presence: true, if: 'email_required?'
  validates :email, uniqueness: true, if: 'email_required?'

  after_create :assign_default_role

  def login
    name || email.split('@').first
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence || login
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
