# frozen_string_literal: true

module ActiveAdmin
  module Documents
    class CategoryPolicy < ApplicationPolicy
      def index? = super_admin? || admin?

      def create? = super_admin? || admin?

      def show? = super_admin? || admin?

      def update? = super_admin? || admin?

      def destroy? = super_admin?
    end
  end
end
