class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :read, to: :view

    can :view, Event, published: true
    can :view, Company, published: true
    can :view, Company::Member, approved: true

    can :manage, User, id: user.id

    if user.admin?
      can :manage, Event
      can :manage, User
      can :publish, Event
      can :manage, EventParticipation

      can :manage, Company
      can :publish, Company
      can :manage, Company::Member
      can :manage, Company::MembershipRequest
    end
    
    if user.member?
      can :create, Company
      can :update, Company, founder_id: user.id
      can :update, Company do |company|
        company.admin?(user)
      end
      can :view, Company, founder_id: user.id
      cannot :publish, Company

      can :create, Company::MembershipRequest
      can :update, Company::MembershipRequest do |request|
        request.company.admin?(user)
      end
      can :manage, Company::Member do |member|
        member.company.admin?(user)
      end
      can :destroy, Company::Member, user_id: user.id


      can :create, Event
      can :view, Event, organizer_id: user.id
      can :update, Event, organizer_id: user.id
      cannot :publish, Event

      can :create, EventParticipation
      can :destroy, EventParticipation, user_id: user.id
    end
  end
end
