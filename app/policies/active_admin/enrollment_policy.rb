# frozen_string_literal: true

module ActiveAdmin
  class EnrollmentPolicy < ApplicationPolicy
    def index?
      admin? || super_admin?
    end

    def create?
      admin? || super_admin?
    end

    def show?
      admin? || super_admin?
    end

    def edit?
      admin? || super_admin?
    end

    def update?
      admin? || super_admin?
    end

    def destroy?
      admin? || super_admin?
    end
  end
end
