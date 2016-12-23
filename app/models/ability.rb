class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    persisted_in_db = User.exists?(user)

    if persisted_in_db
      can [:edit, :update, :destroy], user
    end
    return if user.is_fresh?

    can [:read, :active, :recent], User
    can [:read, :upcoming, :past, :ics], Event, published: true

    # Eh, can we do it in another way?
    if persisted_in_db
      can :create, Event
      can :find, Place
      can [:edit, :update, :destroy], organizer_id: user.id
    end

    if user.moderator?
      can [:read, :update, :destroy, :publish], Event
    elsif user.admin?
      can :manage, :all
    end
  end
end
