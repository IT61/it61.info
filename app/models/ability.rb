class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :manage, :all
    elsif user.moderator?
      can [:read, :edit, :publish!], Event, published: false
      can :index, User
      # todo: can view and edit event participants
    end

    can [:read, :participate], Event, published: true
    can :show, User
    can :crud, User, id: user.id
  end
end
