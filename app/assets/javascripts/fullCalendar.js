document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    plugins: ['dayGrid', 'bootstrap'],
    themeSystem: 'bootstrap',
    locale: 'fr',
    header: {
      left: 'dayGridMonth, dayGridWeek, dayGridDay',
      center: 'title',
      right: 'today prev,next'
    },
    events: '/missions.json'
  });

  calendar.render();
})