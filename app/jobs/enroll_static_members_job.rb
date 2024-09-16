# frozen_string_literal: true

class EnrollStaticMembersJob < ApplicationJob # rubocop:disable Style/Documentation
  queue_as :default

  def perform(enrollment_service = StaticMembersRecruiter.new)
    @enrollment_service = enrollment_service

    @enrollment_service.call
  end

  after_perform do
    ActionCable.server.broadcast 'notifications', reports: @enrollment_service.reports
  end
end
