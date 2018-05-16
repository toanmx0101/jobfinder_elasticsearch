$( document ).on('turbolinks:load', function() {
$('#thread_content').scrollTop($('#thread_content')[0].scrollHeight);
  $('.sender-item').click(function(){
    $('.sender-item').removeClass('active-sender-item');
    $(this).addClass('active-sender-item')
  });
  $(".message-input").on('keyup', function (e) {
    if (e.keyCode == 13) {
      $('.sender-mess-item').append('<div class="sender-mess-item__content"><div class="sender-mess-item__avatar"><span class="sender-mess-time"></span></div><div class="sender-mess-item__content_right"><div class="sender-mess-item__text right-mess-text">' + $(this).val() + '</div></div></div>');
      $('#thread_content').scrollTop($('#thread_content')[0].scrollHeight);
      var mes = $(this).val()
      $(".message-input").val("");
      $.ajax({
        type: 'POST',
        url: '/messages',
        data: { 
                content: mes,
                conversation_id: $('#thread_content').attr('data-conversation')
              },
        dataType: 'json',
        success: function(data) {
          
        }
      });
    }
  });
  // $(".message-input").on('focus', function(){
  //   $('#thread_content').attr('data-status', 'read')
  //   $.ajax({
  //     type: 'PATCH',
  //     url: '/conversation'
  //     data: {
  //       id: $('#thread_content').attr('data-conversation')
  //     }
  //   })
  // });
});