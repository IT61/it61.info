class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    persisted_in_db = User.exists?(user.id)

    give_fresh_privileges(user, persisted_in_db)
    give_mature_privileges(user, persisted_in_db) unless user.fresh?
  end

  private

  def give_fresh_privileges(user, persisted_in_db)
    if persisted_in_db
      can [:edit, :update, :destroy], user
    end

    can [:read, :active, :recent], User
    can [:read, :upcoming, :past, :ics], Event, published: true
  end

  def give_mature_privileges(user, persisted_in_db)
    if persisted_in_db
      can [:create], Event
      can [:participate, :leave], Event, published: true
      can :find, Place
      can [:profile, :edit, :settings, :settings_update], User, id: user.id
      can [:show, :edit, :update, :destroy], Event, organizer_id: user.id
      can [:create, :edit, :update, :publish, :unpublish], Postrelease do |p|
        p.event.organizer_id == user.id
      end
    end

    if user.moderator?
      can [:read, :update, :destroy, :publish, :unpublish], Event
    elsif user.admin?
      can :manage, :all
    end
  end
end
