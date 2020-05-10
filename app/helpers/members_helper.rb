# frozen_string_literal: true

# Helpers for Member-related views
module MembersHelper
  def month_total_hours(member, month_number)
    member
      .enrollments
      .select { |enroll| enroll.mission.start_date.month == month_number }
      .reduce(0.0) { |sum, enrollment| sum + enrollment.duration }
  end
end
