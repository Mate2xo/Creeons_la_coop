//= require moment
//= require moment/fr.js
//= require tempusdominus-bootstrap-4
//= require recurring_select
//= require lib/recurring_select/fr

document.addEventListener('turbolinks:load', function () {
  const missionStartDate = document.getElementById('missionStartDate');
  if (missionStartDate) {
    $('#missionStartDate').datetimepicker({
      locale: 'fr',
      widgetPositioning: { horizontal: 'left' },
      date: moment(missionStartDate.defaultValue, 'YYYY-MM-DD hh:mm:ss'),
    });
  }

  const missionDueDate = document.getElementById('missionDueDate');
  if (missionDueDate) {
    $('#missionDueDate').datetimepicker({
      locale: 'fr',
      useCurrent: false,
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(missionDueDate.defaultValue, 'YYYY-MM-DD hh:mm:ss'),
    });
  }

  const recurrenceCheckbox = document.getElementById('missionRecurrentCheckbox');
  if (recurrenceCheckbox) {
    if (recurrenceCheckbox.checked) $('#recurrence-selector').show();
    recurrenceCheckbox.addEventListener('change', function (_e) {
      $('#recurrence-selector').toggle(150);
    });
  }
});
