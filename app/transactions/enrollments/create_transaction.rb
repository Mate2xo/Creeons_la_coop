# frozen_string_literal: true

module Enrollments
  # create enrollments after prepare params
  class CreateTransaction
    include Dry::Transaction

    step :validate
    tee :prepare
    step :create

    def validate(input, mission:)
      return Success(input) if mission.max_member_count.nil?
      return Success(input) if mission.members.count < mission.max_member_count

      failure_message = I18n.t('enrollments.create.max_member_count_reached')
      Failure(failure_message)
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
  end
end
