class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :read, to: :view

    can :view, Event, published: true
    can :manage, User, id: user.id

    if user.admin?
      can :manage, Event
      can :manage, EventParticipation
    end

    if user.member?
      can :create, EventParticipation
      can :destroy, EventParticipation, user_id: user.id
    end
  end
end
