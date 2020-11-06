# frozen_string_literal: true

class Mission::SlotPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin?
  end

  def update?
    true
  end

  def destroy?
    admin?
  end
end
