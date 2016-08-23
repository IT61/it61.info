class User < ApplicationRecord
  @fresh = false

  mount_uploader :avatar, ImageUploader

  enum role: { member: 0, admin: 1, moderator: 2 }

  # Devise modules
  devise :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:github, :facebook, :google_oauth2, :vkontakte]

  has_many :social_accounts
  has_many :owner_of_events, class_name: "Event", foreign_key: "organizer_id"
  has_many :event_participations, dependent: :destroy
  has_many :member_in_events, class_name: "Event", through: :event_participations, source: :event

  phony_normalize :phone, as: :normalized_phone, default_country_code: "RU"

  validates_presence_of :phone, if: :sms_reminders?
  validates_presence_of :email, if: :email_required?
  validates_presence_of :role
  validates_uniqueness_of :email, case_sensitive: false
  validates_plausible_phone :phone, country_code: "RU"

  # В случае, если OAuth провайдер не предоставляет email, в базу может быть записана пустая строка,
  # что приведет к нарушению уникальности index_users_on_email
  before_save :nullify_empty_email

  before_create :assign_defaults

  scope :notify_by_email, -> { where(email_reminders: true).where.not(email: nil) }
  scope :notify_by_sms, -> { where(sms_reminders: true).where.not(phone: nil) }
  scope :subscribed, -> { where(subscribed: true) }
  scope :with_email, -> { where.not(email: nil) }
  scope :active, -> { order(last_sign_in_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  def self.from_omniauth(auth)
    User.where(email: auth.info.email).first_or_create do |u|
      u.email = auth.info.email unless auth.info.email.nil?
      u.name = auth.info.name
    end
  end

  def add_social(auth)
    SocialAccount.from_omniauth auth, self
  end

  def create_event(event_params, place_params)
    Event.new(event_params) do |e|
      e.organizer = self
      e.place ||= Place.first_or_create_place(place_params)
    end
  end

  def full_name
    [first_name, last_name].compact.join(" ").presence || name
  end

  def pic
    avatar.url.blank? ? "user_default.png" : avatar
  end

  def manager?
    admin? || moderator?
  end

  def remember_me
    true
  end

  def event_participations
    EventParticipation.unscoped { super }
  end

  def subscribe!
    self.subscribed = true
    save!
  end

  def fresh?
    @fresh
  end

  def has_events?
    not (member_in_events.empty? && owner_of_events.empty?)
  end

  def has_google_refresh_token?
    !google_refresh_token.blank?
  end

  def can_fill_entry_form?(event)
    event.closed? || event.user_participated?(self)
  end

  private

  def assign_defaults
    self.role ||= 0
    self.email_reminders ||= false
    self.sms_reminders ||= false
    self.subscribed ||= false
    @fresh = true
  end

  def email_required?
    subscribed? || email_reminders?
  end

  def restore_event_participations
    # Идентификаторы заявок пользователя на участие в мероприятиях, которые не удалены
    ids = EventParticipation.only_deleted.joins(:event).
          where("events.deleted_at is null").
          where(user_id: id).
          pluck(:id)
    EventParticipation.restore ids
  end

  def nullify_empty_email
    self.email = nil unless email.present?
  end
end
