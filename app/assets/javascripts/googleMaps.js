function initMap() {
  var addresses = [];
  for (let i = 0; i < arguments.length; i++) {
    addresses[i] = arguments[i];
  }

  // Set up shop location for centering position on the shop when viewing multiple markers
  var creil = { lat: 49.2667, lng: 2.4833 };
  // The map, centered at desired location
  if (addresses.length > 1) {
    var map = new google.maps.Map(
      document.getElementById('map'),
      { zoom: 9, center: creil }
    ); 
  } else { 
    var map = new google.maps.Map(
      document.getElementById('map'),
      { zoom: 14, center: addresses[0] }
    );
  }

  // The markers, positioned at desired location
  for (let i = 0; i < addresses.length; i++) {
    var marker = new google.maps.Marker({ position: addresses[i], map: map });
  }
};