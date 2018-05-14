class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(counter, message)
    ActionCable.server.broadcast 'message_channel',  counter: render_counter(counter), message: render_message(message), id: message.conversation.receiver_id
  end

  private

  def render_counter(counter)
    ApplicationController.renderer.render(partial: 'messages/counter', locals: { counter: counter })
  end

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
