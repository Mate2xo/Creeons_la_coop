# frozen_string_literal: true

module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    # NOTE: This is not used right now, but serves as a documenting example.
    # We keep this constant definition to follow Zeitwerk convention.
    #
    # def show?
    #   case record.name
    #   when "Dashboard"
    #     true
    #   else
    #     false
    #   end
    # end
    #
    # class Scope < Scope
    #   def resolve
    #     scope.all
    #   end
    # end
  end
end
