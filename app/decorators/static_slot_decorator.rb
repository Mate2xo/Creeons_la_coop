# frozen_string_literal: true

class StaticSlotDecorator < ApplicationDecorator # rubocop:disable Style/Documentation
  delegate_all

  def full_display
    minute = if object.minute.zero?
               '00'
             else
               object.minute
             end

    "#{StaticSlot.human_enum_name('week_day', object.week_day)}
     #{object.hour}h#{minute}
     #{h.t('.week')} #{object.week_type}"
  end

  def hour_display
    minute = if object.minute.zero?
               '00'
             else
               object.minute
             end
    "#{object.hour}h#{minute}"
  end
end
