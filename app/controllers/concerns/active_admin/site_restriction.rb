# frozen_string_literal: true

module ActiveAdmin
  # manage access to active admin ressource
  module SiteRestriction
    # Overriding active admin method in order to get an active admin namespace for pundit
    # This override drive active admin to retrieve policy in active_admin namespace
    # https://github.com/activeadmin/activeadmin/blob/1a6c6a95e3c34cbe558e4899d6852eb0134ef542/lib/active_admin/base_controller/authorization.rb#L67
    # see: https://github.com/activeadmin/activeadmin/blob/1a6c6a95e3c34cbe558e4899d6852eb0134ef542/lib/active_admin/pundit_adapter.rb#L13
    # see: https://github.com/activeadmin/activeadmin/blob/1a6c6a95e3c34cbe558e4899d6852eb0134ef542/lib/active_admin/pundit_adapter.rb#L32
    #
    # For Pundit::NotAuthorizedError
    # see: https://github.com/varvet/pundit/blob/a09548c826b85ced18a2e54ec6195f68cb61dad2/lib/pundit.rb#L24
    # see: https://github.com/varvet/pundit/blob/a09548c826b85ced18a2e54ec6195f68cb61dad2/lib/pundit.rb#L59
    def authorize!(action, subject = nil)
      subject = [:active_admin, subject]
      return if authorized? action, subject

      raise Pundit::NotAuthorizedError.new(
        user: current_active_admin_user,
        query: action,
        policy_class: subject
      )
    end
  end
end
