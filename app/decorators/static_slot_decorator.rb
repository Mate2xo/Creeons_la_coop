# frozen_string_literal: true

class StaticSlotDecorator < ApplicationDecorator # rubocop:disable Style/Documentation
  delegate_all

  def full_display
    minute = if object.start_time.min < 10
               "0#{object.start_time.min}"
             else
               object.start_time.min
             end

    "#{StaticSlot.human_enum_name('week_day', object.week_day)} #{object.start_time.hour}h#{minute} #{h.t('active_admin.resource.show.week')} #{object.week_type}"
  end
end
