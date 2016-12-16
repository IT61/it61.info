module Publisher
  attr_reader :publisher, :event

  def initialize(event, publisher)
    @publisher = publisher
    @event = event
  end

  def publish!
    event.published!
    event.published_at = Time.current
    event.published_by = publisher
    event.save!
  end

  def unpublish!
    event.published = false
    event.save!
  end
end
