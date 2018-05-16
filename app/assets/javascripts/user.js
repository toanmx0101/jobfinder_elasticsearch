$( document ).on('turbolinks:load', function() {
  $('.main-seach-job').on('focus', function(){
    $('.search-history').show();
  });
  $('.main-seach-job').focusout(function() {
    $('.search-history').hide();
  });
});
$(document).ready(function (){
  $('html, body').animate({
      scrollTop: $("#userProfileNavigation").offset().top - 61
  }, 500);
  });
