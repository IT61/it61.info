class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    persisted_in_db = user.persisted?

    give_fresh_privileges(user, persisted_in_db)
    give_mature_privileges(user, persisted_in_db) unless user.fresh?
  end

  private

  def give_fresh_privileges(user, persisted_in_db)
    if persisted_in_db
      can [:edit, :update, :destroy], user
    end

    can [:read, :active, :recent], User
    can [:read, :upcoming, :past, :ics], Event, published: true
  end

  def give_mature_privileges(user, persisted_in_db)
    if persisted_in_db
      can [:create], Event
      can [:attend, :leave], Event, published: true
      can :find, Place
      can [:profile, :edit, :settings, :settings_update], User, id: user.id
      can [:read, :edit, :update, :destroy], Event, organizer_id: user.id
      can [:create, :destroy], :attendee
      can [:index], attendee: { event: { organizer_id: user.id } }
    end

    if user.moderator?
      can :manage, Event
    elsif user.admin?
      can :manage, :all
    end
  end
end
