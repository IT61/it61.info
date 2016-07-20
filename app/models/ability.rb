# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :upcoming, :past, to: :index_categories
    alias_action :create, :read, :update, :destroy, :to => :crud

    # Common abilities
    can :read, UserDecorator # 0_0
    can :read, User
    can :read, Company
    can [:read, :index_categories], Event, published?

    # Cut off unauthorized users
    return if user.nil? || user.role.nil?

    can :crud, User, id: user.id
    can :crud, UserDecorator, id: user.id

    can :places, Event
    can [:participate, :register], Event, published?
    can [:create, :read, :update], Event, organizer?(user)

    if user.admin?
      can :manage, :all
    elsif user.moderator?
      can [:read, :edit, :publish!], Event, not_published?
      # todo: can view and edit event participants
    end
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
