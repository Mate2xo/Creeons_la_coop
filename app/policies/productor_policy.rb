# frozen_string_literal: true

class ProductorPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    super_admin? || admin?
  end

  def update?
    super_admin? || admin?
  end

  def destroy?
    super_admin? || manager?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def manager?
    user.role == "admin" && record.managers.include?(user)
  end
end
