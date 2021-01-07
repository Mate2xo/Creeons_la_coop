# frozen_string_literal: true

# MemberDecorator
class MemberDecorator < Draper::Decorator
  decorates_association :static_slots
  delegate_all

  def worked_hours_in_the_last_three_months
    h.safe_join(hours_per_month.map { |month_total| h.content_tag(:p, month_total) }.reverse)
  end

  def time_slot_already_taken?(time_slot, mission)
    enrollment = member.enrollments.find_by(mission_id: mission.id)
    return false if enrollment.nil?

    enrollment.start_time <= time_slot && time_slot < enrollment.end_time
  end

  private

  def hours_per_month
    3.times.with_object([]) do |n, array|
      array[n] = "#{I18n.localize(Date.current - n.month, format: :only_month)} :
                                  #{model.monthly_worked_hours(Date.current - n.month)}"
    end
  end
end
