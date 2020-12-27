# frozen_string_literal: true

class EnrollmentDecorator < ApplicationDecorator # rubocop:disable Style/Documentation
  delegate_all

  def already_taken?(time_slot)
    return false if enrollment.id.nil?

    enrollment.start_time <= time_slot && time_slot < enrollment.end_time
  end
end
