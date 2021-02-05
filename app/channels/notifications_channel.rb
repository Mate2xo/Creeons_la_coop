class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
