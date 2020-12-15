class EnrollStaticMembersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    StaticMembersRecruiter.call
  end
end
