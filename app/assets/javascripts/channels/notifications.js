App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  received(data) {
    let html = `<div class='flash flash_alert'>
                  <ul id='reports'>  </ul>
                </div>`
    $('.flashes').append(html); //We use the flash management of active admin
    data.reports.forEach(rapport => this.appendLine(rapport));
  },
  appendLine(report) {
    let line = this.createLine(report);
    $('#reports').append(line);
  },
  createLine(report) {
    return `<li> ${report} </li>`;
  }
});
