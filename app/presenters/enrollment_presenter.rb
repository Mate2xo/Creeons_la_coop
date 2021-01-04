# frozen_string_literal: true

class EnrollmentPresenter # rubocop:disable Style/Documentation
  def initialize(enrollment)
    @enrollment = enrollment
  end

  def default_start_time
    return nil if @enrollment.start_time.nil?

    @enrollment.start_time.strftime('%H:%M')
  end

  def default_end_time
    return nil if @enrollment.end_time.nil?

    @enrollment.end_time.strftime('%H:%M')
  end
end
