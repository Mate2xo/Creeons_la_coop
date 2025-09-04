//= require full_calendar
//= require js.cookie

document.addEventListener('turbolinks:load', () => {
  const calendarEl = document.getElementById('calendar');
  if (!calendarEl) {
    return;
  }

  const calendar = new FullCalendar.Calendar(calendarEl, {
    plugins: ['dayGrid', 'timeGrid', 'bootstrap'],
    themeSystem: 'bootstrap',
    height: 'auto',
    defaultView: Cookies.get('planningViewType'),
    defaultDate: Cookies.get('planningCurrentStart'),
    allDaySlot: false,
    firstDay: 1,
    locale: 'fr',
    timeZone: 'UTC', // override browser default (since the shop is local)
    minTime: '06:00:00',
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

    datesRender(info) {
      const weekType = (currentStart) => {
        const reference = new Date(2020, 8, 7);
        const weekInMiliSeconds = 60 * 60 * 24 * 7 * 1000;
        let weeksCountBetweenReferenceAndCurrentStart = Math.trunc(
          (currentStart.getTime() - reference.getTime()) / weekInMiliSeconds,
        );
        const weekTypes = ['D', 'A', 'B', 'C'];
        const positiveIdxFromReference = ((weeksCountBetweenReferenceAndCurrentStart % 4) + 4) % 4;
        return weekTypes[positiveIdxFromReference];
      };

      Cookies.set('planningCurrentStart', info.view.currentStart);
      Cookies.set('planningViewType', info.view.type);

      if (info.view.type === 'timeGridWeek') {
        const currentStart = new Date(info.view.currentStart);
        document.getElementsByClassName('fc-center')[0].firstChild.textContent += ` ${weekType(currentStart)}`;
      }
    },

    eventRender(info) {
      const eventEl = info.el.querySelector('.fc-content');

      // Add a truck icon if delivery_expected
      const icon = document.createElement('i');
      icon.classList.add('fas', 'fa-truck');
      icon.style.color = 'yellow';
      if (info.event.extendedProps.delivery_expected) {
        eventEl.insertBefore(icon, eventEl.firstChild);
      }

      // Show enrolled members
      const memberCount = document.createTextNode(`${info.event.extendedProps.members.length} inscrit(s)`);
      eventEl.appendChild(memberCount);

      const memberList = document.createElement('ul');
      memberList.classList.add('memberList');
      info.event.extendedProps.members.forEach((member) => {
        let first_name = document.createElement('li');
        first_name.textContent = member.first_name;
        memberList.appendChild(first_name);
      });
      eventEl.appendChild(memberList);
    },
  });

  calendar.render();
  calendar.changeView(Cookies.get('planningViewType'), Cookies.get('planningCurrentStart'));
});
