var $paginate

var defaultOpts = {
    visiblePages: 3
  }
$( document ).on('turbolinks:load', function() {
  var totalPages = Math.ceil($('#pagination').attr('value')/10)
  defaultOpts["totalPages"] = totalPages
  $paginate = $('#pagination')
  $paginate.twbsPagination(defaultOpts);
  $paginate.on('page', function(evt, page) {
    handleClickCheckbox(evt, page)
  })
});
function getListLocationChecked() {
  var locations = []
  $('.common-locations:checked').each(function() {
    locations.push($(this).val());
  });
  return locations;
}

function getListJobTypeChecked() {
  var job_types = []
  $('.common-jobtypes:checked').each(function() {
    job_types.push($(this).val());
  });
  return job_types;
}

function handleClickCheckbox(event, page) {
  var text = $('.input--text').val();
  var job_type = getListJobTypeChecked()
  var locations = getListLocationChecked()
  var locations_params = '&location%5B%5D=' + locations
  var job_type_params = '&job_type%5B%5D=' + job_type
  var path = '/search?utf8=✓&q=' + $('.input--text').val()

  if (job_type.length > 0) {
    path += job_type_params
  }
  console.log(locations.length)
  if (locations.length > 0) {
    path += locations_params
  }
  window.history.pushState('a', 'a', path);
  job_page = 0
  if (typeof(page) != 'undefined') {
    job_page = page;
    var url = new URL(window.location.href);
    if (url.searchParams.get("location[]") != null) {
      locations = url.searchParams.get("location[]").split(",");
    }
  }
  $.ajax({
    type: 'GET',
    url: '/search',
    data: { q: text,
            location: locations,
            job_type: job_type,
            page: job_page
          },
    dataType: 'json',
    success: function(data) {
      console.log(data);
      
      $('.list-center-content').empty();
      if (locations.length == 0) {
        $('.job-location-checkbox').empty();
        data['common_locations'].forEach(function(lo){
          $('.job-location-checkbox').append('<label class="job-checkbox">' + lo['key'] + ' (' + lo['doc_count'] + ')<input class="common-locations" type="checkbox" value="' + lo['key'] + '" onclick="handleClickCheckbox(this)"><span class="checkmark"></span></label>');
        });

      }
      if (data['jobs'].length > 1) {
        data['jobs'].forEach(function(job){
          showData(job, data);
        });
      } else {
        showData(data['jobs'], data);
      }
      if (parseInt(data['total_results']) < 10) { 
        $('.results-total-count').text('Show ' + data['total_results'] + ' of ' + data['total_results'] + ' results')
      } else {
        $('.results-total-count').text('Show 10 of ' + data['total_results'] + ' results')
      }
      if ($(event).attr("class") == "common-jobtypes" || $(event).attr("class") == "common-locations") {
        $paginate.twbsPagination('destroy');
        $paginate.twbsPagination($.extend({}, defaultOpts, {
          startPage: 1,
          totalPages: Math.ceil(data['total_results']/10)
        }));
        $paginate.on('page', function(evt, page) {
          handleClickCheckbox(evt, page)
        })
      }
      if ($(event).attr("class") != "common-jobtypes") {
        $(".common-jobtypes").each(function(){
          $(this).parent().find('.jt-title').text($(this).val() + ' (0)')
        })
        data['common_job_types'].forEach(function(jt){
          $(".common-jobtypes[value='" + jt['key'] + "'").parent().find('.jt-title').text(jt['key'] + ' (' + jt['doc_count'] + ')');
        })
      }
    }
  });
}
function showData(job, data) {
  var description 
  if (job['description'] !=  null) {
    description = job['description'].substring(0,500) + '...';
  } else {
    var regex = /(<([^>]+)>)/ig;
    description = job['about_candidate'].replace(regex, "").substring(0,500) + '...';
  }
  $('.list-center-content').append('<div class="job-resul-card map"><div class="m__job-result-card"><div class="content"><div class="job-views-and-type"><span class="job-views"><i class="fa fa-eye" style="color: #f8bc48; margin-right: 5px;"></i>'+ job['view_count'] + ' views</span> <span class="job-type">' + job['job_type'] + '</span></div><a href="/jobs/'+ job['id'] +'-' + job['slug'] + '"><div class="job-title"><h3>' + job['title'] + '</h3></div></a><div class="location"><i class="fas fa-map-marker-alt"></i>' + job['location'] + '<div style="float: right">Score ' + data['jobs_score'].find(item => item.job_id === job['id'].toString())['job_score'].toFixed(2) + '</div></div><a href="/jobs/'+ job['id'] +'-' + job['slug'] + '"><div class="job-description"><span>' + description + '</span></div></a></div></div></div>')        
}

