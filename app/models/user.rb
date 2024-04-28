require "csv"

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

  has_many :events_attendees, dependent: :destroy
  has_many :social_accounts, dependent: :destroy
  has_many :owner_of_events, -> { ordered_desc }, class_name: "Event", foreign_key: "organizer_id"
  has_many :member_in_events, -> { published.ordered_desc }, class_name: "Event", through: :events_attendees, source: :event
  has_many :events, through: :events_attendees
  has_and_belongs_to_many :groups

  phony_normalize :phone, as: :normalized_phone, default_country_code: "RU"

  validates :phone, presence: true, phony_plausible: { country_code: "RU" }, if: :sms_reminders?
  validates :email, uniqueness: { allow_blank: true, case_sensitive: false }
  validates :role, presence: true

  before_save :nullify_empty_email
  before_save :downcase_email
  before_create :assign_defaults

  scope :notify_by_email, -> { where(email_reminders: true).where.not(email: nil) }
  scope :notify_by_sms, -> { where(sms_reminders: true).where.not(phone: nil) }
  scope :subscribed, -> { where(subscribed: true) }
  scope :with_email, -> { where.not(email: nil) }
  scope :active, -> { order(last_sign_in_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_name, -> { where("(first_name is not null and last_name is not null) or name is not null") }
  scope :presentable, -> { active.with_name.order(created_at: :desc) }
  scope :team, -> { joins(:groups).where("groups.kind = 2") }
  scope :developers, -> { joins(:groups).where("groups.kind = 1") }
  scope :organized_events, -> { joins(:events).where("organizer_id", self.id).ordered_desc }

  def self.from_omniauth!(auth)
    auth_info = auth.info
    email = auth_info.email.downcase if auth_info.email.present?
    user = User.find_or_initialize_by(email: email)

    if user.new_record?
      user.email = email
      user.name = auth_info.name
      user.first_name = auth_info.first_name
      user.last_name = auth_info.last_name
      user.remote_avatar_url = avatar_from_auth(auth)
    end

    social = SocialAccount.includes(:user).find_or_initialize_by(uid: auth.uid, provider: auth.provider)
    if social.new_record?
      social.link = SocialAccount.link_for(auth)
      user.social_accounts << social
    end

    user.save
    user
  end

  def self.avatar_from_auth(auth)
    if auth.provider == "vkontakte"
      auth.extra.raw_info.photo_400_orig
    end
  end

  def self.to_csv
    attributes = %w{last_name first_name}

    CSV.generate(headers: true) do |csv|
      csv << ["Фамилия", "Имя", "Отметка"]

      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def add_social(auth)
    SocialAccount.from_omniauth(auth, self)
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
      save
    else
      false
    end
  end

  def linked_social_accounts
    social_accounts.filter do |social_account|
      Devise.omniauth_providers.include?(social_account.provider.to_sym)
    end
  end

  def unlinked_social_providers
    Devise.omniauth_providers.map(&:to_s) - linked_social_accounts.map(&:provider)
  end

  private

  def assign_defaults
    self.role ||= 0
    self.email_reminders ||= false
    self.sms_reminders ||= false
    self.subscribed ||= false
  end

  def nullify_empty_email
    self.email = nil unless email.present?
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def fresh_fields_present?
    email.present? && first_name.present? && last_name.present?
  end
end
