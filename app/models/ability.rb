class Ability
  include CanCan::Ability

  def initialize(user)

    if user.nil? || user.role.nil?
      can :read, Event, published?
      can :read, User
      can :read, Company
      return
    end

    alias_action :create, :read, :update, :destroy, :to => :crud

    # todo: add rules for companies later

    if user.admin?
      can :manage, :all
    elsif user.moderator?
      can [:read, :edit, :publish!], Event, not_published?
      can :index, User
      # todo: can view and edit event participants
    end

    can [:read, :participate], Event, published?
    can [:create, :read, :update], Event, organizer?(user)

    can :show, User
    can :crud, User, id: user.id
  end

  private

  def organizer?(user)
    { organizer_id: user.id }
  end

  def published?
    { published: true }
  end

  def not_published?
    { published: false }
  end
end
