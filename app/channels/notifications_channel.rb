class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel"
  end

  def unsubscribed
  end
end
