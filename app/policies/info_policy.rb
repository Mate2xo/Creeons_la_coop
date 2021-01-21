# frozen_string_literal: true

class InfoPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user || record.published
  end

  def create?
    admin? || super_admin? || redactor?
  end

  def update?
    admin? || super_admin? || redactor?
  end

  def destroy?
    super_admin? || redactor? || record.author == user
  end

  class Scope < Scope
    def resolve
      user ? scope.all : scope.where(published: true)
    end
  end
end
