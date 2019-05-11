# frozen_string_literal: true

class ProductorPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin? || super_admin?
  end

  def update?
    admin? || super_admin?
  end

  def destroy?
    productor_manager? || super_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def productor_manager?
    user.role == "admin" && record.managers.include?(user)
  end
end
