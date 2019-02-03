# frozen_string_literal: true

class InfoPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.role == 'super_admin'
  end

  def update?
    user.role == 'super_admin'
  end

  def destroy?
    user.role == 'super_admin'
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
