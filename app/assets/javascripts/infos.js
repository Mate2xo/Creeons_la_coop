document.addEventListener('turbolinks:load', () => {
  // store the currently selected tab name in the url #hash
  $('ul.nav-tabs > li > a').on('shown.bs.tab', (e) => {
    const tabTarget = $(e.target)
      .attr('href')
      .substr(1);
    window.location.hash = tabTarget;
  });

  // on page load: switch to the tab matching the url #hash
  const { hash } = window.location;
  $(`#infosTabs a[href="${hash}"]`).tab('show');
});
