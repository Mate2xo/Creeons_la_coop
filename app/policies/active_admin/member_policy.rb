# frozen_string_literal: true

module ActiveAdmin
  class MemberPolicy < ApplicationPolicy
    def index?
      admin? || super_admin?
    end

    def create?
      super_admin?
    end

    def show?
      admin? || super_admin?
    end

    def edit?
      super_admin? || record == user
    end

    def update?
      super_admin? || record == user
    end

    def destroy?
      super_admin?
    end
  end
end
