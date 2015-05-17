class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # all log on user can index items
  def index?
    true
  end

  # administrator, author and author's teammates can show items
  def show?
    user.admin? or ( !record[:author_id].nil? and user.teammate?(record[:author_id]) )
  end

  # all log on user can create items
  def create?
    true
  end

  def new?
    create?
  end

  # administrator or author can update the items
  def update?
    user.admin? or ( !record[:author_id].nil? and record[:author_id] == user.id )
  end

  def edit?
    update?
  end

  # Only administrator can destroy items
  def destroy?
    user.admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # All record has author_id and author_id in the teammates of current user
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      elsif scope.respond_to?('attribute_method?') and scope.attribute_method?(:author_id)
        scope.where(:author_id => user.teammates.map(&:id))
      else
        scope.where('1=0')
      end
    end
  end
end

