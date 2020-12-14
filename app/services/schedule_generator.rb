# frozen_string_literal: true

# It generates a planning for the next month and enroll the members with have a static slot
class ScheduleGenerator < ApplicationService
  attr_reader :errors

  def initialize(current_member)
    @current_member = current_member
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

  private

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
      mission = Mission.create(name: 'permanence_clac',
                               description: 'permanence_clac',
                               start_date: current_hour,
                               due_date: current_hour + 180.minutes,
                               min_member_count: 2,
                               max_member_count: 4,
                               event: false,
                               author: @current_member)
      Slot::Generator.call(mission)
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
end
