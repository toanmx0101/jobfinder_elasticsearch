App.notifications = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if parseInt($('#thread_content').attr("data_user")) == parseInt(data.id)
      $('#thread_content .sender-mess-item').append "#{data.message}"
