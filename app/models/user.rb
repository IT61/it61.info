class User < ActiveRecord::Base
  mount_uploader :avatar_image, UserAvatarUploader

  authenticates_with_sorcery!

  enum role: { member: 0, admin: 1 }

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :owner_of_events, class_name: 'Event', foreign_key: 'organizer_id'
  has_many :event_participations, dependent: :destroy
  has_many :member_in_events, class_name: 'Event', through: :event_participations, source: :event

  # Участие в организациях
  has_many :company_members, dependent: :destroy

  validates :password, presence: true, if: 'password_required?'
  validates :password, length: { minimum: 3 }, if: 'password.present?'
  validates :password, confirmation: true, if: 'password_required?'

  validates :email, presence: true, if: 'email_required?'
  validates :email, uniqueness: true, if: 'email_required?'

  phony_normalize :phone, as: :normalized_phone, default_country_code: 'RU'
  validates_plausible_phone :phone, country_code: 'RU'
  validates :phone, presence: true, if: :sms_reminders?

  after_create :assign_default_role
  # В случае, если OAuth провайдер не предоставляет email в базу может быть записана пустая строка,
  # что приведет в нарушению уникальности index_users_on_email
  before_save :nullify_empty_email

  scope :notify_by_email, -> { where(email_reminders: true).where.not(email: nil) }
  scope :notify_by_sms, -> { where(sms_reminders: true).where.not(phone: nil) }
  scope :subscribed, -> { where(subscribed: true) }
  scope :with_email, -> { where.not(email: nil) }
  scope :admins, -> { where(role: 1) }

  def login
    name || email.split('@').first
  end

  def full_name
    [first_name, last_name].compact.join(' ').presence || login
  end

  def event_participations
    EventParticipation.unscoped { super }
  end

  def subscribe!
    self.subscribed = true
    save!
  end

  private

  def password_required?
    (new_record? && authentications.empty?) || password.present?
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

  def restore_event_participations
    # Идентификаторы заявок пользователя на участие в мероприятиях, которые не удалены
    ids = EventParticipation.only_deleted.joins(:event)
                            .where('events.deleted_at is null')
                            .where(user_id: id)
                            .pluck(:id)
    EventParticipation.restore ids
  end

  def nullify_empty_email
    self.email = nil unless email.present?
  end
end
