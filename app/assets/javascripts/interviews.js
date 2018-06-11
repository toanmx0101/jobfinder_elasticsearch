$( document ).on('turbolinks:load', function() {
  $('#inputSimpleSearchUser').on('input', function(){
    if ($('#inputSimpleSearchUser').val().length > 1) {
      $.ajax({
        type: 'GET',
        url: '/simple_search_user',
        data: {username: $('#inputSimpleSearchUser').val()},
        dataType: 'json',
        success: function(data) {
          $('.interviewer-search-results').empty();
          data.forEach(function(item){
            $('.interviewer-search-results').append('<div class="content"><div class="user-icon"><img src="' + item.avatar_url + '"></div><div class="user-infor"><div class="username">' + item.username + '</div><div>'+ item.work_position +'</div></div><div style="display: flex;margin: auto;"><i class="far fa-plus-square fa-2x" onclick="addInterview(\''+item.username+'\',\''+item.work_position+'\', \'' + item.avatar_url + '\', \'' +item.id+ '\')" style="cursor: pointer;"></i></div></div>');
          });
        }
      });
    } else {
      $('.interviewer-search-results').empty();
    }
  });

  $('#inputSimpleSearchJobInterview').on('input', function(){
    if ($('#inputSimpleSearchJobInterview').val().length > 2) {
      $.ajax({
        type: 'GET',
        url: '/simple_search_job',
        data: {title: $('#inputSimpleSearchJobInterview').val(), limit: true},
        dataType: 'json',
        success: function(data) {
          $('.job-search-results').empty();
          data.forEach(function(item){
            $('.job-search-results').append('<div class="job-search-result"><div class="id"># ' + item.id + '<i class="far fa-plus-square fa-lg" style="cursor: pointer" onclick="addJobLink(\'' + item.id + '\', \'' + item.title +'\')"></i></div><div class="p-l-j-job-title">' + item.title + '</div></div>')
          });
        }
      });
    } else {
      $('.job-search-results').empty();
    }
  });
});
function addInterview(name, work_position, avatar_url, id) {
  $('.selected-interviewer').empty();
  $('.selected-interviewer').append('<div class="content"><div class="user-icon"><img src="'+avatar_url+'"></div><div class="user-infor"><div class="username">'+name+'</div><div>'+work_position+'</div></div><div class="view-profile" onclick="sendMailSelect()" style="display: flex;padding: 6px 10px;"><i class="fas fa-check" style="margin-right: 5px;margin-top: 2px;"></i>Mail</div></div><input id="interviewer_id" value="'+id+'" type="hidden" name="interview[interviewer_id]"><input type="checkbox" checked hidden="true" id="sendMailCheckbox" name=interview[sendmail]>');
  $('.interviewer-search-results').empty();
  $('#inputSimpleSearchUser').val('');
  $('#inputSimpleSearchUser').hide();
  $('.fa-search-user').show();
}
$('.fa-search-user').on('click', function(){
  $('#inputSimpleSearchUser').show();
  $(this).hide();
});
function sendMailSelect() {
  console.log($('#sendMailCheckbox').is(':checked'))
  if ($('#sendMailCheckbox').is(':checked')) {
    $('.fa-check').removeClass('fas').removeClass('fa-check').addClass('far').addClass('fa-square');
    $('#sendMailCheckbox').removeAttr('checked');
  } else {
    $('.fa-square').removeClass('far').removeClass('fa-square').addClass('fas').addClass('fa-check');
    $('#sendMailCheckbox').prop('checked', true);
  }
}
function addJobLink(id, title) {
  $('#inputSimpleSearchJobInterview').hide();
  $('.job-search-results').hide();
  $('.job-selected-link').append('<div class="job-search-result"><div class="id"># '+ id +'</div><div class="p-l-j-job-title">' + title + '</div></div><input id="job_id" value="'+id+'" type="hidden" name="interview[job_id]">')
  $('.fa-search-job').show();
}
