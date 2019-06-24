# frozen_string_literal: true

class RecurrentMissions
  def generate(mission_template)
    recurrence_end = limit_recurrence_end_date(mission_template)

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

  def self.validate(mission_template)
    recurrence_end = mission_template.recurrence_end_date.to_date

    return "Veuillez renseigner le type de récurrence, ainsi que sa date de fin" if mission_template.recurrence_rule.empty? || recurrence_end.nil?
    return "La date de fin de récurrence ne peut être établie sur une date passée" if recurrence_end < Date.today

    true
  end

  private

  def limit_recurrence_end_date(mission_template)
    recurrence_end = mission_template.recurrence_end_date.to_date
    recurrence_end = 1.month.from_now.end_of_month if recurrence_end > 1.month.from_now.end_of_month

    recurrence_end
  end
end
