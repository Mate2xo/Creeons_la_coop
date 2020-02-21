document.addEventListener('ajax:complete', (e) => {
  const xhr = e.detail[0];
  const flashType = xhr.getResponseHeader('Flash-message-type');
  const flashMessage = xhr.getResponseHeader('Flash-message');

  if (flashMessage) {
    showAjaxFlashMessage(flashType, flashMessage);
  }
});

function showAjaxFlashMessage(type, msg) {
  const flashDiv = document.getElementById('flash_messages');
  flashDiv.innerHTML = '';

  const message = document.createElement('div');
  const cssClass = chooseFlashMessageCssClass(type);
  message.classList.add('alert', 'text-center', cssClass);
  message.textContent = decodeURIComponent(escape(msg));

  flashDiv.appendChild(message);
}

function chooseFlashMessageCssClass(flashType) {
  switch (flashType) {
    case 'notice':
      return 'alert-success';
    case 'alert':
      return 'alert-warning';
    case 'error':
      return 'alert-danger';
    default:
      return undefined;
  }
}
