class GroupPolicy < ApplicationPolicy
  attr_reader :user, :record

  # all log on user can see items
  def show?
    true
  end

  # administrator can create items
  def create?
    user.admin?
  end

  def new?
    create?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end

