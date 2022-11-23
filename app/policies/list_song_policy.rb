class ListSongPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.admin? ? scope.all : scope.where(user: user)
      else
        scope.where public: true
      end
    end
  end

  # def show?
  #   record.list.user == user || user.admin?
  # end

  def create?
    record.list.user == user || user.admin?
  end

  def update?
    record.song.user == user || user.admin?
  end

  def destroy?
    record.list.user == user || user.admin?
  end

  def destroy_multiple?
    record.each do |ls|
      ls.list.user == user || user.admin?
    end
  end

  def move?
    record.list.user == user || user.admin?
  end
end
