class Event < ActiveRecord::Base
  mount_uploader :title_image, EventTitleImageUploader

  belongs_to :organizer, class_name: 'User'

  has_many :event_participations, dependent: :destroy
  has_many :participants, class_name: 'User', through: :event_participations, source: :user

  validates :title, presence: true
  validates :organizer, presence: true
  validates :place, presence: true
  validates :published_at, presence: true, if: :published?

  scope :ordered_desc, -> { order(started_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :upcomming, -> { where('started_at > ?', DateTime.current ) }
  scope :today, -> { started_in(DateTime.current) }
  scope :started_in, -> (datetime) {
    where('started_at > :start and started_at < :end',
          start: datetime.beginning_of_day,
          end: datetime.end_of_day)
  }
  scope :published_at, -> (datetime) {
    where('published_at > :start and published_at < :end',
          start: datetime.beginning_of_day,
          end: datetime.end_of_day)
  }
  scope :not_notified_about, ->{ where(subscribers_notification_send: false) }

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = self.started_at.strftime("%Y%m%dT%H%M%S")
    event.summary = self.title
    event.description = self.description
    event.location = self.place
    event.created = self.created_at
    event.last_modified = self.updated_at
    # TODO: remove hardcoded line
    # event.uid = event.url = "http://it52.info/events/#{self.id}"
    event
  end

  def user_participated?(user)
    user && event_participations.find_by(user_id: user.id)
  end

  def participation_for(user)
    event_participations.find_by(user_id: user.id)
  end

  def past?
    started_at < DateTime.current
  end

  def publish!
    self.toggle :published
    self.published_at = DateTime.current
    save!
  end

  def cancel_publication!
    self.toggle :published
    self.published_at = nil
    save!
  end

  def title_with_date
    formatted_date = I18n.l(started_at, format: :date_digits)
    "#{title} (#{formatted_date})"
  end

  private

  def restore_event_participations
    # Идентификаторы заявок на участие в мероприятии, которые оставили не удаленные пользователи
    ids = EventParticipation.only_deleted.joins(:user)
                            .where('users.deleted_at is null')
                            .where(event_id: id)
                            .pluck(:id)
    EventParticipation.restore ids
  end

end
