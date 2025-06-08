# frozen_string_literal: true

module ActiveAdmin
  class MissionPolicy < ApplicationPolicy
    def index?
      admin? || super_admin?
    end

    def create?
      admin? || super_admin?
    end

    def show?
      admin? || super_admin?
    end

    def update?
      admin? || super_admin?
    end

    def destroy?
      super_admin? || (admin? && record.author == user)
    end
  end
end
