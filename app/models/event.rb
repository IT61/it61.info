class Event < ActiveRecord::Base
  mount_uploader :title_image, EventTitleImageUploader
  acts_as_paranoid

  belongs_to :organizer, class_name: 'User'

  has_many :event_participations, dependent: :destroy
  has_many :participants, class_name: 'User', through: :event_participations, source: :user

  validates :title, presence: true
  validates :organizer, presence: true
  validates :place, presence: true

  scope :ordered_desc, -> { order(started_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :upcomming, -> { where('started_at > ?', Time.zone.now.to_date ) }
  scope :today, -> { started_in(Time.zone.now) }
  scope :started_in, -> (datetime) {
    where('started_at > :start and started_at < :end',
          start: datetime.beginning_of_day,
          end: datetime.end_of_day)
  }

  after_restore :restore_event_participations

  def user_participated?(user)
    user && event_participations.find_by(user_id: user.id)
  end

  def participation_for(user)
    event_participations.find_by(user_id: user.id)
  end

  def past?
    started_at < DateTime.now
  end

  def publish!
    self.toggle :published
    save!
  end

  def cancel_publication!
    self.toggle :published
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
