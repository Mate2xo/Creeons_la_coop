App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  received(data) {
    let html = `<div class='flash flash_alert'>
                  <p> ${I18n.t('admin.members.js.end_of_auto_enrollment')} </p>
                  <ul id='reports'>  </ul>
                </div>`

    $('.flashes').append(html); //We use the flash management of active admin
    data.reports.forEach(report => this.appendLine(report));
  },
  appendLine(data) {
    let line = this.createLine(data);
    $('#reports').append(line);
  },
  createLine(data) {
    return `<li> ${data.message} </li>`;
  }
});
