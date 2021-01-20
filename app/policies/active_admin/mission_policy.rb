# frozen_string_literal: true

module ActiveAdmin
  class MissionPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
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
      super_admin? || record.author == user
    end

    class Scope < Scope # rubocop:disable Style/Documentation
      def resolve
        scope.all
      end
    end
  end
end
