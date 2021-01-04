# frozen_string_literal: true

# Mission validator
class DurationValidator < ActiveModel::Validator
  def validate(mission)
    return false if mission.start_date.nil? || mission.due_date.nil?
    return true if mission.genre == 'event'

    duration_valid?(mission)
  end

  private

  def duration_maximum(mission)
    return true if mission.duration / 60 / 60 <= 10

    mission.errors.add :duration, I18n.t('activerecord.errors.models.mission.attributes.duration.maximum')
    false
  end

  def duration_minimum(mission)
    return true if mission.due_date > mission.start_date

    mission.errors.add :duration, I18n.t('activerecord.errors.models.mission.attributes.duration.minimum')
    false
  end

  def duration_multiple(mission)
    return true if mission.genre != 'regulated'
    return true if ((mission.duration / 60).round % 90).zero?

    mission.errors.add :duration, I18n.t('activerecord.errors.models.mission.attributes.duration.multiple')
    false
  end

  def duration_valid?(mission)
    return false unless duration_minimum(mission)
    return false unless duration_maximum(mission)
    return false unless duration_multiple(mission)

    true
  end
end
