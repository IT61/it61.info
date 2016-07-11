$(document).ready(function () {

  $resultsContainer = $('#dropdown-container');

  var model = {
    viewedLocations: [],
    locationsToSubmit: []
  };

  // careful! be more specific later
  $('body').on('click', function() {
    model.setViewed([]);
  });

  model.add = function(location) {
    model.reset();
    model.locationsToSubmit.push(location);
    // sync hidden fields
    $('#event_address').val(location.meta.text);
    $('#event_latitude').val(location.coordinates[0]);
    $('#event_longitude').val(location.coordinates[1]);
  };

  model.reset = function() {
    model.locationsToSumit = [];
    $('#event_address').val('');
    $('#event_latitude').val('');
    $('#event_longitude').val('');
  }

  model.setViewed = function(locations) {
    viewedLocations = locations;
    updateContainer($resultsContainer, viewedLocations);
  };

  var parser = {
    parse: function(rawData) {
      var objects = rawData.geoObjects,
          count = rawData.metaData.geocoder.results;
      return parser.parseObjects(objects, count);
    },
    parseObject: function(object) {
      var metaData = object.properties.get('metaDataProperty').GeocoderMetaData,
          coordinates = object.geometry._coordinates;
      return {
        meta: metaData,
        coordinates: coordinates
      }
    },
    parseObjects: function(objects, count) {
      res = [];
      for (var i = 0; i < count; i++) {
        var object = objects.get(i);
        if (object !== null) {
          res.push(parser.parseObject(object));
        }
      };
      return res;
    }
  };

  function updateContainer($container, objects) {
    $container.text('');
    objects.forEach(function(object) {
      $row = $('<div class="location-suggestion">').text(object.meta.text);
      $container.append($row);

      $row.on('click', function() {
        model.add(object);
        model.setViewed([]);
      });

    });
  }

  function bindGeocoder() {
    var locationInput = $('#location');
    function search(event) {
      var inputText = event.target.value;
      if (inputText.length === 0) {
        return;
      }

      ymaps.geocode(inputText, {
        boundedBy: [[46.061107, 37.603739], [49.073023, 42.767521]], // todo: add more bounds
        strictBounds: true,
        results: 5,
        key: 'AHZRg1cBAAAAVJVoUwIAHgEeJgNyoRKXD7E-Ckx19BG3CxsAAAAAAAAAAAATskglMkTslg1wn1UJZXWqc-V2FQ=='
      }).then(function(res) {
        var resultData = parser.parse(res);
        model.setViewed(resultData);
      });
    }
    locationInput.on('input', search);
    locationInput.on('focus', search);
  }
  ymaps.ready(bindGeocoder);
});
