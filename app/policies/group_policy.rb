# frozen_string_literal: true

# Policy of group management
class GroupPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    super_admin?
  end

  def show?
    true
  end

  def edit?
    super_admin?
  end

  def update?
    super_admin?
  end

  def destroy?
    super_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
