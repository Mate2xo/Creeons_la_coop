# frozen_string_literal: true

class MemberPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    super_admin?
  end

  def show?
    true
  end

  def update?
    super_admin? || user == record
  end

  def destroy?
    super_admin? || user == record
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
