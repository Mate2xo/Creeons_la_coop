# frozen_string_literal: true

# Helpers for views/missions
module MissionsHelper
  def partial_enrollment?(enrollment)
    mission_start = enrollment.mission.start_date.strftime('%R')
    mission_end = enrollment.mission.due_date.strftime('%R')
    member_begins_after_mission_start = enrollment.start_time.strftime('%R') != mission_start
    member_finishes_before_mission_end = enrollment.end_time.strftime('%R') != mission_end

    member_begins_after_mission_start || member_finishes_before_mission_end
  end

  def partial_enrollment_css
    'bg-info rounded text-white p-1'
  end

  def enrollment_duration(enrollment)
    "#{enrollment.start_time&.strftime('%H:%M')} - #{enrollment.end_time&.strftime('%H:%M')}"
  end
end
