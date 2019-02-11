# frozen_string_literal: true

class InfoPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user
  end

  def create?
    admin? || super_admin?
  end

  def update?
    admin? || super_admin?
  end

  def destroy?
    super_admin? || record.author == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
