# frozen_string_literal: true

class DocumentPolicy < ApplicationPolicy
  def index? = true

  def create?
    admin? || super_admin?
  end

  def destroy?
    admin? || super_admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user
        scope.all
      else
        scope.where(published: true)
      end
    end
  end
end
