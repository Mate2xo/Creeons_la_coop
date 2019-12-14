//= require moment
//= require moment/fr.js
//= require tempusdominus-bootstrap-4
//= require recurring_select
//= require recurring_select/fr

$(document).on('turbolinks:load', () => {
  const start_date = document.getElementById('mission_start_date').defaultValue;
  $('#mission_start_date').datetimepicker({
    locale: 'fr',
    widgetPositioning: {
      horizontal: 'left',
    },
    date: moment(start_date, 'YYYY-MM-DD hh:mm:ss'),
  });

  const due_date = document.getElementById('mission_due_date').defaultValue;
  $('#mission_due_date').datetimepicker({
    locale: 'fr',
    useCurrent: false,
    widgetPositioning: {
      horizontal: 'left',
    },
    date: moment(due_date, 'YYYY-MM-DD hh:mm:ss'),
  });

  $('#mission_recurrent').on('change', () => {
    $('#recurrence-selector').toggle(150);
  });
});
