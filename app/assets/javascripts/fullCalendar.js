//= require full_calendar

document.addEventListener('turbolinks:load', () => {
  const calendarEl = document.getElementById('calendar');
  if (calendarEl) {
    const calendar = new FullCalendar.Calendar(calendarEl, {
      plugins: ['dayGrid', 'timeGrid', 'bootstrap'],
      themeSystem: 'bootstrap',
      height: 'auto',
      defaultView: 'timeGridWeek',
      firstDay: 1,
      locale: 'fr',
      timeZone: 'UTC', // override browser default (since the shop is local)
      minTime: '09:00:00',
      maxTime: '23:00:00',
      buttonText: {
        today: "Aujourd'hui",
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

      eventRender(info) {
        const eventEl = info.el.querySelector('.fc-content');
        const icon = document.createElement('i');

        icon.classList.add('fas', 'fa-truck');
        icon.style.color = 'yellow';

        if (info.event.extendedProps.delivery_expected) {
          eventEl.insertBefore(icon, eventEl.firstChild);
        }
      },
    });

    calendar.render();
  }
});
