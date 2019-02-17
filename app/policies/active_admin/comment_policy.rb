# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  end
end
