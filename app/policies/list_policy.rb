class ListPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
      if user
        user.admin? ? scope.all : (scope.where(user: user).or scope.where(public: true))
      elsif !user
        scope.where public: true
      end
    end
  end

  def show?
    record.public? ? true : record.user == user || user.admin?
  end

  def new?
    user || user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    record.user == user || (user.present? && user.admin?)
  end

  def destroy?
    (record.user == user || user.admin?) if user
  end
end
