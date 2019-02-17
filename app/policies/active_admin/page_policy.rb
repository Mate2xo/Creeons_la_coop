# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when "Dashboard"
        true
      else
        false
      end
    end

    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
