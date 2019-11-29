//= require full_calendar

document.addEventListener('turbolinks:load', () => {
  const calendarEl = document.getElementById('calendar');
  if (calendarEl) {
    const calendar = new FullCalendar.Calendar(calendarEl, {
      plugins: ['dayGrid', 'timeGrid', 'bootstrap'],
      themeSystem: 'bootstrap',
      height: 'auto',
      locale: 'fr',
      buttonText: {
        today: "aujourd'hui",
        day: 'Jour',
        month: 'Mois',
        week: 'Semaine',
      },
      header: {
        left: 'dayGridMonth,timeGridWeek,timeGridDay',
        center: 'title',
        right: 'prev,next',
      },
      events: '/missions.json',

      eventClick(info) {
        $.get(info.event.show_url);
      },
    });

    calendar.render();
  }
});

