# frozen_string_literal: true

# Generates a set of common missions for a given month. This allows admins not having to create the same kind
# of missions over and over again. This service is similar to the RecurrentMission generator, but it is intended
# to be used in a Job rather than from the UI
class ScheduleGenerator
  attr_reader :errors

  def initialize(current_member, start_date)
    @current_member = current_member
    @start_date = start_date
    @errors = []
  end

  def generate_schedule
    valid = true
    Mission.transaction do
      generate_missions_for_a_month
      if @errors.any?
        valid = false
        raise ActiveRecord::Rollback
      end
    end
    valid
  end

  private

  def generate_missions_for_a_month
    current_day = @start_date
    while current_day.month == @start_date.month
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
                               genre: 'regulated',
                               author: @current_member)
      @errors << I18n.t('activerecord.errors.messages.creation_fail', Mission.model_name.human) if mission.errors.any?
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
