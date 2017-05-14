class Event < ActiveRecord::Base
  include PermalinkFor
  permalink_for :permalink_title, as: :pretty
  mount_base64_uploader :cover, ImageUploader
  strip_strings :title

  # Relations
  belongs_to :organizer, class_name: "User"
  belongs_to :place

  has_many :events_attendees
  has_many :attendees, through: :events_attendees

  accepts_nested_attributes_for :place, reject_if: :all_blank, limit: 1

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :organizer, presence: true
  validates :place, presence: true
  validates :published_at, presence: true, if: :published?
  validates :started_at, presence: true
  validates :has_attendees_limit, inclusion: { in: [true, false] }
  validates :attendees_limit, presence: true, numericality: { greater_than_or_equal_to: -1 }

  delegate :title, :address, :latitude, :longitude, to: :place, prefix: true, allow_nil: true

  # Callbacks
  after_save :send_notifications, if: :notify?

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

  def notify?
    published? && !published_was
  end

  def place_attributes=(attributes)
    if attributes["id"].present?
      self.place = Place.find(attributes["id"])
    end
    super
  end

  def user_attended?(user)
    user && attendees.include?(user)
  end

  def past?
    started_at <= DateTime.current
  end

  def upcoming?
    started_at >= Time.current
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

  def to_ical
    IcsService.to_ics_calendar(self)
  end

  def ical_options
    IcsService.file_options_for(self)
  end

  private

  def permalink_title
    formatted_started_at = started_at.to_date.to_s if started_at.present?
    [formatted_started_at, title].compact.join(" ")
  end

  def send_notifications
    SlackService.notify(self) if Rails.env.production?
  end
end
