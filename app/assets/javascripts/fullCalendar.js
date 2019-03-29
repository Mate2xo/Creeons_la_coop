document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    plugins: ['dayGrid'],
    locale: 'fr',
    header: {
      left:   'title',
      center: 'dayGridMonth, dayGridWeek, dayGridDay',
      right:  'today prev,next'
    }
  });

  calendar.render();
})