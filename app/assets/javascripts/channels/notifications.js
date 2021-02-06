App.notifications = App.cable.subscriptions.create("NotificationsChannel", {
  received(data) {
    let html = `<div class='flash flash_alert'>
                  <ul id='reports'>  </ul>
                </div>`
    $('.flashes').append(html); //We use the flash management of active admin
    data.reports.forEach(rapport => this.appendLine(rapport));
  },
  appendLine(data) {
    let line = this.createLine(data);
    $('#reports').append(line);
  },
  createLine(data) {
    return `<li> ${data.message} </li>`;
  }
});
