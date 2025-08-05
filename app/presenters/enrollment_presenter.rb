# frozen_string_literal: true

class EnrollmentPresenter # rubocop:disable Style/Documentation
  attr_reader :enrollment

  def initialize(enrollment)
    @enrollment = enrollment
  end

  def default_start_time
    start_time = enrollment.start_time || enrollment.mission.start_date.to_time
    start_time.strftime('%H:%M')
  end

  def default_end_time
    end_time = enrollment.end_time || enrollment.mission.due_date.to_time
    end_time.strftime('%H:%M')
  end
end
