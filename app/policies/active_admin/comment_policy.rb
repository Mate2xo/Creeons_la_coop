# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    def show?
      super_admin?
    end

    def create?
      super_admin?
    end

    def update?
      super_admin?
    end

    def destroy?
      super_admin?
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
