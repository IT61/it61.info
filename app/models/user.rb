class User < ApplicationRecord
  include Gravtastic
  gravtastic
  mount_uploader :avatar, ImageUploader

  enum role: {
    member: 0,
    admin: 1,
    moderator: 2,
  }

  # Devise modules
  devise :rememberable, :trackable, :omniauthable,
         omniauth_providers: [:github, :facebook, :google_oauth2, :vkontakte]

  has_many :social_accounts
  has_many :owner_of_events, -> { published }, class_name: "Event", foreign_key: "organizer_id"
  has_many :member_in_events, -> { published }, class_name: "Event", through: :event_participations, source: :event
  has_many :event_participations, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_and_belongs_to_many :groups

  phony_normalize :phone, as: :normalized_phone, default_country_code: "RU"

  validates :phone, presence: true, if: :sms_reminders?
  validates :email, presence: true, uniqueness: { case_sensitive: false }, if: :email_required?
  validates :role, presence: true
  validates_plausible_phone :phone, country_code: "RU"

  before_save :nullify_empty_email
  before_create :assign_defaults

  scope :notify_by_email, -> { where(email_reminders: true).where.not(email: nil) }
  scope :notify_by_sms, -> { where(sms_reminders: true).where.not(phone: nil) }
  scope :subscribed, -> { where(subscribed: true) }
  scope :with_email, -> { where.not(email: nil) }
  scope :active, -> { order(last_sign_in_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_name, -> { where("(first_name is not null and last_name is not null) or name is not null") }
  scope :presentable, -> { active.with_name.order("nullif(avatar, '') desc nulls last") }
  scope :team, -> { joins(:groups).where("groups.kind = 2") }
  scope :developers, -> { joins(:groups).where("groups.kind = 1") }

  def self.from_omniauth(auth)
    User.where(email: auth.info.email).first_or_create do |u|
      u.email = auth.info.email.downcase unless auth.info.email.nil?
      u.name = auth.info.name
      u.first_name = auth.info.first_name
      u.last_name = auth.info.last_name
    end
  end

  def add_social(auth)
    SocialAccount.from_omniauth auth, self
  end

  def display_name
    if first_name.presence
      first_name
    else
      full_name
    end
  end

  def full_name
    [first_name, last_name].compact.join(" ").presence || name
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

  def has_events?
    not (member_in_events.empty? && owner_of_events.empty?)
  end

  def has_google_refresh_token?
    !google_refresh_token.blank?
  end

  def can_fill_entry_form?(event)
    event.has_closed_registration? || event.user_participated?(self)
  end

  def update_with_fresh(params)
    assign_attributes(params)
    if fresh_fields_present?
      self.fresh = false

      if save
        yield self
        true
      else
        false
      end
    else
      false
    end
  end

  private

  def assign_defaults
    self.role ||= 0
    self.email_reminders ||= false
    self.sms_reminders ||= false
    self.subscribed ||= false
  end

  def email_required?
    false
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

  def fresh_fields_present?
    email.present? && first_name.present? && last_name.present?
  end
end
