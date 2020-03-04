document.addEventListener('turbolinks:load', () => {
  const messageboardsMetadataNodes = document.querySelectorAll(
    '.thredded--messageboard--meta--counts',
  );
  messageboardsMetadataNodes.forEach((metadata) => {
    if (metadata.textContent.includes("non lu")) {
      metadata.style.fontWeight = 'bold';
    }
  });
});
