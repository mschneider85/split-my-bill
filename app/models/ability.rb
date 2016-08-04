class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.persisted?
      can :manage, :all
      cannot :manage, Group do |group|
        group.users.exclude?(user)
      end
      cannot :destroy, Group do |group|
        group.admin != user
      end
      can [:index, :create], Group
      cannot :show, User do |other_user|
        other_user.friends.exclude?(user)
      end
      can :show, User, id: user.id
      can :index, User
    end
    can :manage, UserReport
  end
end
