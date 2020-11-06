# frozen_string_literal: true

# helpers for facilitate enroll on mission throught slot_time
module Helpers
  module SlotEnrollment
    def enroll(mission, member, time_slots_count = 2)
      time_slots_available = mission.slots.where(member_id: nil).group(:start_time).count.keys.reverse
      while time_slots_available.any? && time_slots_count > 0
        slot = mission.slots.find_by(member_id: nil, start_time: time_slots_available.first)
        slot.update(member_id: member.id)
        time_slots_available.delete(time_slots_available.first)
        time_slots_count -= 1
      end
    end
  end
end
