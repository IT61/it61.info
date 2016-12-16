class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:read, :active, :recent], User
    can [:edit, :update, :destroy], user
    can [:read, :upcoming, :past, :ics], Event, published: true
    can :create, Event
    can [:edit, :update, :destroy], organizer_id: user.id

    if user.moderator?
      can [:read, :update, :destroy, :publish], Event
    elsif user.admin?
      can :manage, :all
    end
  end
end
