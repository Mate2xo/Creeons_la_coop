# frozen_string_literal: true

class EnrollmentPresenter # rubocop:disable Style/Documentation
  attr_reader :enrollment

  ##
  # Initializes a new EnrollmentPresenter with the given enrollment object.
  def initialize(enrollment)
    @enrollment = enrollment
  end

  ##
  # Returns the default start time for the enrollment as a formatted string.
  # Uses the enrollment's start time if available; otherwise, falls back to the mission's start date.
  # @return [String] The start time in '%H:%M' format.
  def default_start_time
    start_time = enrollment.start_time || enrollment.mission.start_date.to_time
    start_time.strftime('%H:%M')
  end

  ##
  # Returns the default end time for the enrollment as a formatted string.
  # Uses the enrollment's end time if available; otherwise, falls back to the mission's due date.
  # @return [String] The end time in '%H:%M' format.
  def default_end_time
    end_time = enrollment.end_time || enrollment.mission.due_date.to_time
    end_time.strftime('%H:%M')
  end
end
