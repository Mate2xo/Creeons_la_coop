# frozen_string_literal: true

module Admin # rubocop:disable Style/Documentation
  module MembersHelper # rubocop:disable Style/Documentation
    def selectable_static_slots
      StaticSlot.all.decorate.map { |static_slot| [static_slot.full_display, static_slot.id] }
    end

    def worked_hours_title_for_given_month(date)
      t('active_admin.resource.index.worked_hours_of_this_month', month: I18n.l(date, format: :only_month))
    end
  end
end
