//= require moment
//= require moment/fr.js
//= require tempusdominus-bootstrap-4
//= require recurring_select
//= require recurring_select/fr

$(document).on('turbolinks:load', () => {
  $('#mission_start_date').datetimepicker({
    locale: 'fr',
  });
  $('#mission_due_date').datetimepicker({
    locale: 'fr',
    useCurrent: false,
  });

  $('#mission_recurrent').on('change', () => {
    $('#recurrence-selector').toggle(150);
  });
});
