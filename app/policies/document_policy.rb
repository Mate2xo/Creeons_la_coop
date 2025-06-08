# frozen_string_literal: true

class DocumentPolicy < ApplicationPolicy
  def create?
    admin? || super_admin?
  end

  def destroy?
    admin? || super_admin?
  end
end
