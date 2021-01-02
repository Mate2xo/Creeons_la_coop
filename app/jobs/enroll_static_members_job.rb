class EnrollStaticMembersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    StaticMembersRecruiter.new.call
  end
end
