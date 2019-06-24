$(document).on('turbolinks:load', function() {
  $("#mission_recurrent").on('change', function() {
    $("#recurrence-selector").toggle(150);
  });
});
