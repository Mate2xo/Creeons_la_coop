# frozen_string_literal: true

class MissionPolicy < ApplicationPolicy
  def enroll?
    true
  end

  def disenroll?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    (user == record.author) || super_admin?
  end

  def destroy?
    (user == record.author) || super_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
