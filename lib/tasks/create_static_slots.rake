# frozen_string_literal: true

# This task is only a one-time use
desc 'create some static slots'
task create_some_static_slots: :environment do
  common_days = %w[Wednesday Thursday Friday]
  StaticSlot.week_types.each_key do |week_type|
    StaticSlot.week_days.each_key do |week_day|
      next unless common_days.include?(week_day)

      create_static_slots_for_one_day(week_type, week_day)
    end
    create_static_slots_for_one_saturday(week_type)
  end
  puts 'creation done'
end

def create_static_slots_for_one_day(week_type, week_day)
  create_static_slots_for_one_morning(week_type, week_day)
  create_static_slots_for_one_afternoon(week_type, week_day)
end

# The date is actually not important here
def create_static_slots_for_one_morning(week_type, week_day)
  current_start_time = DateTime.new(2020, 1, 1, 9, 0)
  StaticSlot.create(week_type: week_type, week_day: week_day, start_time: current_start_time)
  current_start_time += 1.5.hours
  StaticSlot.create(week_type: week_type, week_day: week_day, start_time: current_start_time)
end

def create_static_slots_for_one_afternoon(week_type, week_day)
  current_start_time = DateTime.new(2020, 1, 1, 14, 0)
  4.times do
    StaticSlot.create(week_type: week_type, week_day: week_day, start_time: current_start_time)
    current_start_time += 1.5.hours
  end
end

def create_static_slots_for_one_saturday(week_type)
  current_start_time = DateTime.new(2020, 1, 1, 9, 45)
  6.times do
    StaticSlot.create(week_type: week_type, week_day: 'Saturday', start_time: current_start_time)
    current_start_time += 1.5.hours
  end
end
