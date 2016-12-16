class AdminAbility
  include CanCan::Ability

  def initialize(user)
    can :all, Event
    can :all, User
  end
end
