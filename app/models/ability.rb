class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, User
    can [:edit, :update, :destroy], user
    can :read, Event, published: true
    can :create, Event
    can [:edit, :update, :destroy], organizer_id: user.id

    if user.moderator?
      define_moderator(user)
    end
  end

  private

  def define_moderator(user)
    can [:read, :update, :destroy], Event
  end
end
