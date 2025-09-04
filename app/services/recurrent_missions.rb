# frozen_string_literal: true

class RecurrentMissions
  def generate(mission_template)
    schedule = setup_schedule(mission_template)
    mission_duration = mission_template.due_date - mission_template.start_date

    schedule.all_occurrences.each do |o|
      mission_to_create = mission_template.attributes
      mission_to_create['start_date'] = o
      mission_to_create['due_date'] = o + mission_duration
      Mission.create!(mission_to_create)
    end
  end

  def self.validate(mission_template)
    recurrence_rule = mission_template.recurrence_rule
    recurrence_end = mission_template.recurrence_end_date&.to_date

    return t(:select_recurrence_type_and_end) if recurrence_rule.blank? || recurrence_end.blank?
    return t(:recurrence_end_must_not_be_past) if recurrence_end < Date.current
    return t(:impossible_recurrence) unless RecurringSelect.is_valid_rule? recurrence_rule

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
    cap = 12.months.from_now.end_of_month.to_date
    recurrence_end = cap if recurrence_end > cap

    recurrence_end
  end

  def self.t(key) = I18n.t(key, scope: %i[services recurrent_missions])
end
