# frozen_string_literal: true

module AdminHelper # rubocop:disable Style/Documentation
  def selectable_static_slots
    StaticSlot.all.decorate.map { |static_slot| [static_slot.full_display, static_slot.id] }
  end
end
