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
    user == record || super_admin?
  end

  def destroy?
    user == record || super_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
