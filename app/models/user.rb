# frozen_string_literal: true
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

  validates :email, uniqueness: true

  phony_normalize :phone, as: :normalized_phone, default_country_code: "RU"
  validates_plausible_phone :phone, country_code: "RU"

  validates :phone, presence: true, if: :sms_reminders?
  validates :email, presence: true, if: :email_required?
  validates :role,  presence: true

  # В случае, если OAuth провайдер не предоставляет email, в базу может быть записана пустая строка,
  # что приведет к нарушению уникальности index_users_on_email
  before_save :nullify_empty_email

  before_create :assign_defaults

  scope :notify_by_email, -> { where(email_reminders: true).where.not(email: nil) }
  scope :notify_by_sms, -> { where(sms_reminders: true).where.not(phone: nil) }
  scope :subscribed, -> { where(subscribed: true) }
  scope :with_email, -> { where.not(email: nil) }

  # Авторизация/регистрация пользователя
  def self.from_omniauth(auth)
    social = SocialAccount.where(provider: auth.provider, uid: auth.uid).first_or_create do |soc|
      soc.provider = auth.provider
      soc.uid = auth.uid
      soc.user = User.create do |u|
        u.email = auth.info.email unless auth.info.email.nil?
        u.name = auth.info.name
      end
      soc.link = link_for auth
    end
    SlackService.invite(social.user)
    social.user
  end

  # Добавление социального аккаунта к текущему пользователю
  def add_social(auth)
    social = SocialAccount.where(provider: auth.provider, uid: auth.uid).first_or_create do |soc|
      soc.provider = auth.provider
      soc.uid = auth.uid
      soc.user = self
      soc.link = link_for auth
    end
    social.user
  end

  def full_name
    [first_name, last_name].compact.join(" ").presence || name
  end

  def pic
    avatar.url.blank? ? "user_default.png" : avatar
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

  private

  def link_for(auth)
    provider = auth.provider

    case provider
    when 'google_oauth2'
      auth.extra.raw_info.profile if
        (not auth.extra.raw_info.nil?) && (not auth.extra.raw_info.profile.nil?)
    when 'vkontakte'
      auth.info.urls.Vkontakte if
          (not auth.info.urls.nil?)
    when 'facebook'
      # facebook doesn't give a link to user website
      nil
    when 'github'
      auth.info.urls.GitHub if
        (not auth.info.urls.nil?)
    else
      nil
    end
  end

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
