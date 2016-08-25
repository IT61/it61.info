class Event < ActiveRecord::Base
  include PermalinkFor
  permalink_for :permalink_title, as: :pretty

  mount_uploader :title_image, ImageUploader

  enum registration_type: { opened: 0, closed: 1, paywalled: 2 }

  belongs_to :organizer, class_name: "User"

  has_many :event_participations, dependent: :destroy
  has_many :registrations, dependent: :destroy

  has_many :participants, class_name: "User", through: :event_participations, source: :user do
    def visited
      where("event_participations.visited = ?", true)
    end

    def non_visited
      where("event_participations.visited = ?", false)
    end
  end

  belongs_to :place

  validates_presence_of :title, :description, :organizer, :place
  validates :published_at, presence: true, if: :published?

  scope :ordered_desc, -> { order(started_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :upcoming, -> { where("started_at > ?", DateTime.current) }
  scope :past, -> { where("started_at <= ?", DateTime.current) }
  scope :today, -> { started_in(DateTime.current) }
  scope :started_in, -> (datetime) {
    where("started_at > :start and started_at < :end",
          start: datetime.beginning_of_day,
          end: datetime.end_of_day)
  }
  scope :published_in, -> (from_day, to_day = nil) {
    where("published_at > :from and published_at < :to",
          from: from_day.beginning_of_day,
          to: to_day.end_of_day)
  }
  scope :not_notified_about, -> { where(subscribers_notification_send: false) }

  before_save :set_secret_hash, if: :closed?

  def user_participated?(user)
    user && event_participations.find_by(user_id: user.id)
  end

  def able_to_participate?
    opened? || past?
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

  def publish!
    return if published
    toggle :published
    self.published_at = DateTime.current
    save!
    send_slack_notification
    self
  end

  def cancel_publication!
    self.published = false
    self.published_at = nil
    save!
  end

  def new_participant!(user)
    event_participations << EventParticipation.new(user: user)
  end

  private

  def set_secret_hash
    self.secret_hash = rand(36**20).to_s(36)
  end

  def permalink_title
    formatted_started_at = started_at.to_date.to_s if started_at.present?
    [formatted_started_at, title].compact.join(" ")
  end

  def send_slack_notification
    SlackService.notify(self)
  end
end
