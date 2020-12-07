# frozen_string_literal: true

# Mission validator
class DurationValidator < ActiveModel::Validator
  def validate(mission)
    return false if mission.start_date.nil? || mission.due_date.nil?
    return true if mission.event

    return false unless duration_minimum(mission)
    return false unless duration_multiple(mission)
    return false unless duration_extend(mission)

    true
  end

  private

  def duration_multiple(mission)
    duration_in_minutes = (mission.due_date - mission.start_date) / 60
    return true if (duration_in_minutes % 90).zero?

    mission.errors.add :duration, I18n.t('activerecord.errors.models.mission.attributes.duration.multiple')
    false
  end

  def duration_extend(mission)
    duration_in_minutes = (mission.due_date - mission.start_date) / 60
    return true if duration_in_minutes < 360

    mission.errors.add :duration, I18n.t('activerecord.errors.models.mission.attributes.duration.extend')
    false
  end

  def duration_minimum(mission)
    return true if mission.due_date > mission.start_date

    mission.errors.add :duration, I18n.t('activerecord.errors.models.mission.attributes.duration.minimum')
    false
  end
end
