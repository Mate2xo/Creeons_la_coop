App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  received(data) {
    let html = `<div class='flash flash_alert'>
                  <p> ${I18n.t('admin.members.js.end_of_auto_enrollment')} </p>
                  <ul id='reports'>  </ul>
                </div>`

    $('.flashes').append(html); //We use the flash management of active admin
    data.reports.forEach(report => this.appendLine(report));
  },
  appendLine(report) {
    let line = this.createLine(report);
    $('#reports').append(line);
  },
  createLine(report) {
    return `<li> ${report} </li>`;
  }
});
