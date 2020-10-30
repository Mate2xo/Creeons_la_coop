# frozen_string_literal: true

class DocumentPolicy < ApplicationPolicy

  def index?
    admin? || super_admin?
  end
  
  def create?
    admin? || super_admin?
  end

  def update?
    admin? || super_admin?
  end

  def destroy?
    admin? || super_admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
