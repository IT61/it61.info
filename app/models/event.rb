class Event < ActiveRecord::Base
  include PermalinkFor
  permalink_for :permalink_title, as: :pretty
  mount_uploader :cover, ImageUploader
  strip_strings :title

  # Relations
  belongs_to :organizer, class_name: "User"
  belongs_to :place

  has_many :event_participations, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :participants, class_name: "User", through: :event_participations, source: :user

  accepts_nested_attributes_for :place, reject_if: :invalid_place, limit: 1

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :organizer, presence: true
  validates :place, presence: true
  validates :published_at, presence: true, if: :published?

  delegate :title, :address, :latitude, :longitude, to: :place, prefix: true, allow_nil: true

  # Callbacks
  before_create :set_secret_word
  after_save :send_notifications, if: :published?

  # Scopes
  scope :ordered_desc, -> { order(started_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :upcoming, -> { where("started_at > ?", DateTime.current).ordered_desc }
  scope :past, -> { where("started_at <= ?", DateTime.current).ordered_desc }
  scope :today, -> { started_in(DateTime.current) }
  scope :started_in, ->(datetime) {
    where("started_at > :start and started_at < :end",
          start: datetime.beginning_of_day,
          end: datetime.end_of_day)
  }
  scope :published_in, ->(from_day, to_day = nil) {
    where("published_at > :from and published_at < :to",
          from: from_day.beginning_of_day,
          to: to_day.end_of_day)
  }
  scope :not_notified_about, -> { where(subscribers_notification_send: false) }

  def user_participated?(user)
    user && event_participations.find_by(user_id: user.id)
  end

  def invalid_place(attributes)
    attributes["title"].blank?
  end

  def able_to_participate?
    !has_closed_registration? || past?
  end

  def participation_for(user)
    event_participations.find_by(user_id: user.id)
  end

  def registration_for(user)
    registrations.where(user_id: user.id).first_or_initialize
  end

  def past?
    started_at <= DateTime.current
  end

  def new_participant!(user)
    event_participations << EventParticipation.new(user: user)
  end

  def publish!
    self.published = true
    self.published_at = Time.current
    self.save!
  end

  def unpublish!
    self.published = false
    self.save!
  end

  private

  def set_secret_word
    self.secret_word = rand(36**20).to_s(36)
  end

  def permalink_title
    formatted_started_at = started_at.to_date.to_s if started_at.present?
    [formatted_started_at, title].compact.join(" ")
  end

  def send_notifications
    SlackService.notify(self) if Rails.env.production?
  end
end
