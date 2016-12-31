class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :read, to: :view

    can :view, Event, published: true
    can :manage, User, id: user.id

    if user.admin?
      can :manage, :all
      can :publish, Event
    elsif user.member?
      can :create, Event
      can :view, Event, organizer_id: user.id
      can :update, Event, organizer_id: user.id
      cannot :publish, Event

      can :create, EventParticipation
      can :destroy, EventParticipation, user_id: user.id
    end
  end
end
