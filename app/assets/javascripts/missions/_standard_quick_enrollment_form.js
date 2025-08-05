//= require moment
//= require moment/fr.js
//= require tempusdominus-bootstrap-4

document.addEventListener('turbolinks:load', function () {
  const enrollmentStart = document.getElementById('enrollmentStartTime');
  if (enrollmentStart) {
    $('#enrollmentStartTime').datetimepicker({
      locale: 'fr',
      format: 'LT',
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(enrollmentStart.defaultValue, 'hh:mm'),
    });
  }

  const enrollmentEnd = document.getElementById('enrollmentEndTime');
  if (enrollmentEnd) {
    $('#enrollmentEndTime').datetimepicker({
      locale: 'fr',
      format: 'LT',
      widgetPositioning: {
        horizontal: 'left',
      },
      date: moment(enrollmentEnd.defaultValue, 'hh:mm'),
    });
  }
});
