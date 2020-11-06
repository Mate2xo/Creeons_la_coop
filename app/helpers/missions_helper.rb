# frozen_string_literal: true

# Helpers for views/missions
module MissionsHelper
  def partial_enrollment?(mission, member)
    Mission::Slot.where(member_id: member.id, mission_id: mission.id).count == mission.time_slots_count
  end

  def partial_enrollment_css
    'bg-info rounded text-white p-1'
  end

  def enrollment_duration(enrollment)
    "#{enrollment.start_time&.strftime('%H:%M')} - #{enrollment.end_time&.strftime('%H:%M')}"
  end

  def work_duration(member_id, mission_id)
    minutes = Mission::Slot.where(member_id: member_id, mission_id: mission_id).count * 90
    hours = minutes / 60
    minutes = minutes % 60
    "#{hours}h#{minutes}"
  end

end
