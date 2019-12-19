//= require moment
//= require moment/fr.js
//= require tempusdominus-bootstrap-4
//= require recurring_select
//= require recurring_select/fr

$(document).on('turbolinks:load', () => {
  const missionStartDate = document.getElementById('mission_start_date');
  if (missionStartDate) {
    $('#mission_start_date').datetimepicker({
      locale: 'fr',
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(missionStartDate.defaultValue, 'YYYY-MM-DD hh:mm:ss'),
    });
  }

  const missionDueDate = document.getElementById('mission_due_date');
  if (missionDueDate) {
    $('#mission_due_date').datetimepicker({
      locale: 'fr',
      useCurrent: false,
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(missionDueDate.defaultValue, 'YYYY-MM-DD hh:mm:ss'),
    });
  }

  const dutyDurationStart = document.getElementById('duty_duration_start_time');
  if (dutyDurationStart) {
    $('#duty_duration_start_time').datetimepicker({
      locale: 'fr',
      format: 'LT',
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(dutyDurationStart.defaultValue, 'hh:mm'),
    });
  }

  const dutyDurationEnd = document.getElementById('duty_duration_end_time');
  if (dutyDurationEnd) {
    $('#duty_duration_end_time').datetimepicker({
      locale: 'fr',
      format: 'LT',
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(dutyDurationEnd.defaultValue, 'hh:mm'),
    });
  }

  $('#mission_recurrent').on('change', () => {
    $('#recurrence-selector').toggle(150);
  });
});
