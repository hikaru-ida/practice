$(function() {
  $(document).on('turbolinks:load',function () {
    fadeout_alert();
  });
  function fadeout_alert() {
    setTimeout(function() {
      $('.alert.top-alert').fadeOut("")
    }, 3000);
  }
})
