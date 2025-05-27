# frozen_string_literal: true

module ActiveAdmin
  class ResourceController < BaseController
    # TODO: Remove-me when upgrading to ActiveAdmin v4.
    # @see https://github.com/activeadmin/activeadmin/pull/8143
    module DataAccess
      protected

      # Applies any Ransack search methods to the currently scoped collection.
      # Both `search` and `ransack` are provided, but we use `ransack` to prevent conflicts.
      def apply_filtering(chain)
        @search = chain.ransack(params[:q] || {}, auth_object: active_admin_authorization)
        @search.result
      end
    end
  end
end
