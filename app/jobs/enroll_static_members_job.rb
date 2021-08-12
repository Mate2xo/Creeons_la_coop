# frozen_string_literal: true

class EnrollStaticMembersJob < ApplicationJob # rubocop:disable Style/Documentation
  queue_as :default

  def perform
    @recruiter = StaticMembersRecruiter.new
    @recruiter.call
  end

  after_perform do
    ActionCable.server.broadcast 'notifications', reports: @recruiter.reports
  end
end
