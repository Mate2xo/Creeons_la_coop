# frozen_string_literal: true

class MemberPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    (user.role == "super_admin")
  end

  def show?
    true
  end

  def update?
    (user.role == "super_admin") || user == record
  end

  def destroy?
    (user.role == "super_admin") || user == record
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
