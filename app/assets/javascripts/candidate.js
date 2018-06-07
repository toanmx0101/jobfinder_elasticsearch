var $paginate

var defaultOpts = {
    visiblePages: 3
  }
$( document ).on('turbolinks:load', function() {
  if ($('#candidatePagination').length > 0) {
    var totalPages = Math.ceil($('#candidatePagination').attr('value')/5)
    defaultOpts["totalPages"] = totalPages
    $paginate = $('#candidatePagination')
    $paginate.twbsPagination(defaultOpts);
    $paginate.on('page', function(evt, page) {
      $.ajax({
        type: 'GET',
        url: '/candidates',
        data: { 
                username: $('#username').val(),
                work_position: $('#work_position').val(),
                skills: $('#skills').val(),
                page: page
              },
        dataType: 'json',
        success: function(data) {
          $('.results-candidate').empty();
          $('.cc-profiles').empty();

          data['candidates'].forEach(function(candidate){
            var pro =  '<div class="candidate-profile" id="candidate'+ candidate.id + '"><div class="c-p-content"><div><div class="c-p-user-profile"><img class="" src="'+ candidate.avatar_url +'"/><div class="score">Score </div></div></div><div><div class="c-p-username">' + candidate.username +'</div><div style="text-align: center;">'+candidate.work_position+'</div><div class="c-p-link"><div class="c-p-view"><a href="/jf/' + candidate.username + '" target="_blank">View profile</a></div><div class="c-p-mes">Send message</div></div><div class="c-p-tags"><h2>Tags</h2><div>'
            if (candidate['tags']) {
              candidate['tags'].forEach(function(tag){
                pro = pro + '<div class="c-p-tag-item">' + tag["term"] + '</div>'
              })
            }
            $('.results-candidate').append('<div class="c-cs-content-res"><div class="candidate-item"><div class="content"><div class="user-icon"><img src="' + candidate['avatar_url'] + '"></div><div class="user-infor"><div class="username">'+ candidate.username + '</div><div>'+ candidate.work_position +'</div></div><div class="view-profile" onclick="viewProfile(this)" data-user="'+candidate.id+'">View</div></div></div></div>')
            $('.cc-profiles').append( pro +
              '</div></div><div class="c-p-experience"><h2> Description</h2><div class="c-p-experience-short-content">' + candidate.description +
              '</div></div><div class="c-p-experience"><h2> Experience</h2><div class="c-p-experience-short-content">' +
              candidate.experience + '</div></div></div></div></div>')
          })

        }
      });
    })
  }
});
function viewProfile(event) {
  $('.candidate-profile').hide()
  $('#candidate' + $(event).data('user')).show();
}
function nextpageCandidates(event, page) {
  console.log($('.p-l-j-job .selected').data('job'))
}

function handleClickPLJJOB(event) {
  $('.p-l-j-job').removeClass('selected');
  $(event).addClass('selected');
  $.ajax({
    type: 'GET',
    url: '/candidates',
    data: { 
            job_id: $('.selected').data('job')
          },
    dataType: 'json',
    success: function(data) {
      console.log(data);
      $paginate.twbsPagination('destroy');
      $paginate.twbsPagination($.extend({}, defaultOpts, {
        startPage: 1,
        totalPages: Math.ceil(data['total_results']/10)
      }));
      $paginate.on('page', function(evt, page) {
        handleClickCheckbox(evt, page)
      })
      $('.results-candidate').empty();
      $('.cc-profiles').empty();
      
      data['candidates'].forEach(function(candidate){
        var pro =  '<div class="candidate-profile" id="candidate'+ candidate.id + '"><div class="c-p-content"><div><div class="c-p-user-profile"><img class="" src="'+ candidate.avatar_url +'"/><div class="score">Score </div></div></div><div><div class="c-p-username">' + candidate.username +'</div><div style="text-align: center;">'+candidate.work_position+'</div><div class="c-p-link"><div class="c-p-view"><a href="/jf/' + candidate.username + '" target="_blank">View profile</a></div><div class="c-p-mes">Send message</div></div><div class="c-p-tags"><h2>Tags</h2><div>'
        if (candidate['tags']) {
          candidate['tags'].forEach(function(tag){
            pro = pro + '<div class="c-p-tag-item">' + tag["term"] + '</div>'
          })
        }
        $('.results-candidate').append('<div class="c-cs-content-res"><div class="candidate-item"><div class="content"><div class="user-icon"><img src="' + candidate['avatar_url'] + '"></div><div class="user-infor"><div class="username">'+ candidate.username + '</div><div>'+ candidate.work_position +'</div></div><div class="view-profile" onclick="viewProfile(this)" data-user="'+candidate.id+'">View</div></div></div></div>')
        $('.cc-profiles').append( pro +
          '</div></div><div class="c-p-experience"><h2> Description</h2><div class="c-p-experience-short-content">' + candidate.description +
          '</div></div><div class="c-p-experience"><h2> Experience</h2><div class="c-p-experience-short-content">' +
          candidate.experience + '</div></div></div></div></div>')
      })
    }
  });
}