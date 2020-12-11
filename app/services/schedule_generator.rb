# frozen_string_literal: true

# It generates a planning for the next month and enroll the members with have a static slot
class ScheduleGenerator < ApplicationService
  def initialize
    @errors = []
  end

  def generate_schedule
    valid = true
    Mission.transaction do
      generate_missions_for_next_month
      if @errors.any?
        valid = false
        raise ActiveRecord::Rollback
      end
    end
    valid
  end

  def generate_missions_for_next_month
    current_day = (DateTime.current + 1.month).at_beginning_of_month
    next_month = current_day.month
    while current_day.month == next_month
      generate_missions_for_a_day(current_day)
      current_day += 1.day
    end
  end

  def generate_missions_for_a_day(current_day)
    return if current_day.strftime('%a') == 'Sun'

    generate_current_hours(current_day).each do |current_hour|
      mission = FactoryBot.create :mission, name: 'permanence clac', description: 'permanence clac',
                                            start_date: current_hour, min_member_count: 2
      enroll_members_with_static_slot(mission, current_hour)
      enroll_members_with_static_slot(mission, current_hour + 90.minutes)
    end
  end

  def generate_current_hours(current_day) # rubocop:disable Metrics/AbcSize
    current_hours = []
    if current_day.strftime('%a') == 'Sat'
      current_hours << current_day + 9.75.hours
      current_hours << current_day + 12.75.hours
      current_hours << current_day + 15.75.hours
    else
      current_hours << current_day + 9.hours
      current_hours << current_day + 14.hours
      current_hours << current_day + 17.hours
    end
  end

  def enroll_members_with_static_slot(mission, current_hour) # rubocop:disable Metrics/AbcSize
    static_slot = StaticSlot.find_by(week_day: current_hour.strftime('%A'),
                                     hour: current_hour.hour, minute: current_hour.min,
                                     week_type: determine_week_type(current_hour))
    return if static_slot.nil?

    members = static_slot.members
    format_mission_slots(members.count, mission)
    members.each do |member|
      slot = mission.slots.find_by(start_time: current_hour)
      slot.update(member_id: member.id)
    end
  end

  def format_mission_slots(members_count, mission)
    return if mission.max_member_count >= members_count

    params[:max_member_count] = members_count
    mission_updator = Mission::Updator.new(mission, params)
    @errors << 'format mission failed' unless mission_updator.call
  end

  def determine_week_type(current_hour)
    reference = DateTime.new(2020, 9, 7)
    week_in_seconds = 60 * 60 * 24 * 7
    week_count_between_reference_and_current_hour = (current_hour.at_beginning_of_week.to_i - reference.to_i) / week_in_seconds

    week_types = %w[D A B C]
    week_types[week_count_between_reference_and_current_hour % 4]
  end
end
