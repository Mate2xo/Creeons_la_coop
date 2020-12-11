# frozen_string_literal: true

class StaticSlotDecorator < ApplicationDecorator # rubocop:disable Style/Documentation
  delegate_all

  def full_display
    "#{StaticSlot.human_enum_name('week_day', object.week_day)}
     #{object.hour}h#{minute}
     #{h.t('.week')} #{object.week_type}"
  end
end
