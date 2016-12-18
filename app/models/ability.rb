class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:read, :active, :recent], User
    can [:read, :upcoming, :past, :ics], Event, published: true

    # Eh, can we do it in another way?
    if User.exists?(user)
      can [:edit, :update, :destroy], user
      can :create, Event
      can [:edit, :update, :destroy], organizer_id: user.id
    end

    if user.moderator?
      can [:read, :update, :destroy, :publish], Event
    elsif user.admin?
      can :manage, :all
    end
  end
end
