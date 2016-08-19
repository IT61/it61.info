"use strict";

$(document).ready(function() {
  var location = {
    coordinates: [40, 41],
    addressLine: "test"
  };

  Geocoder.ready(function() {
    var container = $('#map')[0];
    Geocoder.buildMap(container, location);
  });
});
