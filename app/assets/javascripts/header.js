$( document ).on('turbolinks:load', function() {
  $('.account-link, .notification-link, .message-link').click(function(){
    $(this).find("#open_notification").empty();
    $(this).children(".js-dropdown-content").toggle();
    $(this).addClass('active');
    if ($(this).attr('class') == 'message-link') {
      $.ajax({
        type: 'GET',
        url: '/update_all_conversations',
        dataType: 'json',
        success: function(data) {
          $('#open_notification').val('');
        }
      })
    }
  });
  $('.mark-read-all').click(function(){
    $('.readed').removeClass('read');
  });
  $(document).mouseup(function (e){
    var container = new Array();
    container.push($('.account-dropdown'));
    container.push($('.notification-dropdown'));
    container.push($('.message-dropdown'));
    
    $.each(container, function(key, value) {
      if (!$(value).is(e.target) // if the target of the click isn't the container...
        && $(value).has(e.target).length === 0) // ... nor a descendant of the container
      {
        $(value).hide();
        $('.a-item-content').removeClass('active');
      }
    });
  });
});