# frozen_string_literal: true

module ActiveAdmin
  class InfoPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
    def index?
      super_admin? || admin? || redactor?
    end

    def create?
      super_admin? || admin? || redactor?
    end

    def show?
      super_admin? || admin? || redactor?
    end

    def edit?
      super_admin? || admin? || redactor?
    end

    def update?
      super_admin? || admin? || redactor?
    end

    def destroy?
      super_admin? || admin? || redactor?
    end
  end
end
