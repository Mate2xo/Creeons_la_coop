# frozen_string_literal: true

class RecurrentMissions
  def generate(mission_template)
    schedule = setup_schedule(mission_template)
    mission_duration = mission_template.due_date - mission_template.start_date

    schedule.all_occurrences.each do |o|
      mission_to_create = mission_template.attributes
      mission_to_create["start_date"] = o
      mission_to_create["due_date"] = o + mission_duration
      mission = Mission.create!(mission_to_create)
      Slot::Generator.call(mission) unless mission.event
    end
  end

  def self.validate(mission_template)
    recurrence_rule = mission_template.recurrence_rule
    recurrence_end = mission_template.recurrence_end_date.to_date

    return "Veuillez renseigner le type de récurrence, ainsi que sa date de fin" if recurrence_rule.empty? || recurrence_end.nil?
    return "La date de fin de récurrence ne peut être établie sur une date passée" if recurrence_end < Date.today
    return "Le type de récurrence sélectionné est impossible" unless RecurringSelect.is_valid_rule? recurrence_rule

    true
  end

  private

  def setup_schedule(mission_template)
    recurrence_end = limit_recurrence_end_date(mission_template)

    rule = RecurringSelect.dirty_hash_to_rule mission_template.recurrence_rule
    rule.until recurrence_end

    schedule = IceCube::Schedule.new(mission_template.start_date, end_time: recurrence_end)
    schedule.add_recurrence_rule rule

    schedule
  end

  def limit_recurrence_end_date(mission_template)
    recurrence_end = mission_template.recurrence_end_date.to_date
    recurrence_end = 1.month.from_now.end_of_month if recurrence_end > 1.month.from_now.end_of_month

    recurrence_end
  end
end
