"use strict";

$(document).ready(function() {

  var $mapTrigger = $('#map-trigger'),
      $map = $('#map')[0];

  if (!$mapTrigger || !$mapTrigger.length) {
    return;
  }

  var location = $mapTrigger.data('location');

  if (!location) {
    return;
  }

  Geocoder.ready(function() {
    Geocoder.buildMap($map, location);
  });
});
