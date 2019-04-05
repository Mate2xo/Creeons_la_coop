document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    plugins: ['dayGrid', 'timeGrid', 'bootstrap'],
    themeSystem: 'bootstrap',
    locale: 'fr',
    header: {
      left: 'dayGridMonth,timeGridWeek,timeGridDay',
      center: 'title',
      right: 'today prev,next'
    },
    events: '/missions.json',
    
    eventClick: function(info) {
      $.get(info.event.show_url)
    }
  });

  calendar.render();
})