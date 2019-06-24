# frozen_string_literal: true

class RecurrentMissions
  def generate(mission_template, recurrence_end)
    rule = RecurringSelect.dirty_hash_to_rule mission_template.recurrence_rule
    rule.until recurrence_end

    schedule = IceCube::Schedule.new(mission_template.start_date, end_time: recurrence_end)
    schedule.add_recurrence_rule rule

    mission_duration = mission_template.due_date - mission_template.start_date
    schedule.all_occurrences.each do |o|
      mission_to_create = mission_template.attributes
      mission_to_create["start_date"] = o
      mission_to_create["due_date"] = o + mission_duration
      Mission.create!(mission_to_create)
    end
  end
end
