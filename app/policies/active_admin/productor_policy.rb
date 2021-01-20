# frozen_string_literal: true

module ActiveAdmin
  class ProductorPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
    def index?
      super_admin?
    end

    def create?
      super_admin?
    end

    def show?
      super_admin?
    end

    def edit?
      super_admin?
    end

    def update?
      super_admin?
    end

    def destroy?
      super_admin?
    end

    class Scope < Scope # rubocop:disable Style/Documentation
      def resolve
        scope.all
      end
    end
  end
end
