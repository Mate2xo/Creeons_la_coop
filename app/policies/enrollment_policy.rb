# frozen_string_literal: true

class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    super_admin?
  end

  def show?
    super_admin?
  end

  def create?
    super_admin?
  end

  def update?
    super_admin?
  end

  def destroy?
    super_admin?
  end
end
