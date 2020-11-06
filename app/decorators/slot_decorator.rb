# frozen_string_literal: true

# MissionDecorator

class SlotDecorator < ApplicationDecorator
  delegate_all

  def formated_start_time
    object.start_time.strftime('%Hh%M')
  end
end

