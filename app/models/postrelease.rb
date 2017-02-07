class Postrelease < ApplicationRecord
  belongs_to :event
  has_many :materials, dependent: :destroy

  after_save :schedule_proc

  accepts_nested_attributes_for :materials, reject_if: :all_blank, allow_destroy: true

  delegate :organizer_id, to: :event, allow_nil: true

  def publish!
    self.published = true
    self.save!
  end

  def unpublish!
    self.published = false
    self.save!
  end

  private

  def schedule_proc
    ProcessPostrelease.perform_now(id)
  end
end
