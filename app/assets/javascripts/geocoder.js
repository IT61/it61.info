$(document).ready(function () {

  $resultsContainer = $('#dropdown-container');

  var model = {
    viewedLocations: [],
    locationsToSubmit: []
  };

  model.add = function(location) {
    model.locationsToSubmit.push(location);
  };

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
        res.push(parser.parseObject(object));
      };
      return res;
    }
  };

  function updateContainer($container, objects) {
    $container.text('');
    objects.forEach(function(object) {
      $row = $('<div class="location-suggestion">').text(object.meta.text);
      $container.append($row);
    });
  }

  function bindGeocoder() {
    $('#location').on('input', function(event) {
      var search = event.target.value;
      ymaps.geocode(search, {
        boundedBy: [[46.061107, 37.603739], [49.073023, 42.767521]],
        strictBounds: true,
        results: 5
      }).then(function(res) {
        var resultData = parser.parse(res);
        model.setViewed(resultData);
      });
    });
  }
  ymaps.ready(bindGeocoder);
});
