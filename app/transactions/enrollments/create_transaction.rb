# frozen_string_literal: true

module Enrollments
  # create enrollments after prepare params
  class CreateTransaction
    include Dry::Transaction

    step :validate
    step :check_cash_register_proficiency
    tee :prepare
    step :create

    def validate(input, mission:)
      return Success(input) if mission.max_member_count.nil?
      return Success(input) if mission.members.count < mission.max_member_count

      failure_message = I18n.t('enrollments.create.max_member_count_reached')
      Failure(failure_message)
    end

    def check_cash_register_proficiency(input, mission:, member:)
      return Success(input) if mission.genre != 'regulated' || sufficient_proficiency?(mission, member)

      input['start_time'].each do |time_slot|
        slots_count = mission.available_slots_count_for_a_time_slot(time_slot)
        return Failure(check_cash_register_proficiency_failure_message(time_slot)) if slots_count < 2
      end

      Success(input)
    end

    def prepare(input, mission:)
      return Success(input) unless mission.genre == 'regulated'

      input['end_time'] = input['start_time'].last.to_datetime + 90.minutes
      input['start_time'] = input['start_time'].first.to_datetime

      Success(input)
    end

    def create(input)
      enrollment = Enrollment.new(input)
      if enrollment.save
        Success(input)
      else
        failure_message = "#{I18n.t('.enroll_error')} #{enrollment.errors.full_messages.join(', ')}"
        Failure(failure_message)
      end
    end

    def check_cash_register_proficiency_failure_message(time_slot)
      I18n.t('enrollments.create.insufficient_proficiency',
             start_time: time_slot.to_datetime.strftime('%H:%M'),
             end_time: (time_slot.to_datetime + 90.minutes).strftime('%H:%M'))
    end

    def sufficient_proficiency?(mission, member)
      requirement_level = Mission.cash_register_proficiency_requirements[mission.cash_register_proficiency_requirement]
      mastery_level = Member.cash_register_proficiencies[member.cash_register_proficiency]
      mastery_level >= requirement_level
    end
  end
end
