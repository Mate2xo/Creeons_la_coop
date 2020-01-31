class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
		members = Member.all

    # Do something later
  end
end
