(function() {
    "use strict";
    window.Geocoder = function () {

        var baseCity = "Ростов-на-Дону",
            suggestionsURL = "/places/find",
            bounds = [[46.061107, 37.603739], [49.073023, 42.767521]];

        var myMap;

        var parser = {
            nullifyBaseCity: function (city) {
                return city === baseCity ? undefined : city;
            },
            parse: function (rawData) {
                var objects = rawData.geoObjects,
                    count = rawData.metaData.geocoder.results;
                return parser.parseObjects(objects, count);
            },
            parseObject: function (object) {
                var addressLine = [
                    parser.nullifyBaseCity(object.getLocalities()[0]),
                    object.getThoroughfare(),
                    object.getPremiseNumber(),
                    object.getPremise()
                ].filter(function (n) {
                    return n != undefined
                }).join(", ");

                var coordinates = object.geometry._coordinates;

                return {
                    addressLine: addressLine,
                    coordinates: coordinates,
                    isRelevant: baseCity === object.getLocalities()[0]
                }
            },
            parseObjects: function (objects, count) {
                var res = [];
                for (var i = 0; i < count; i++) {
                    var object = objects.get(i);
                    if (object !== undefined) {
                        var geoObj = parser.parseObject(object);
                        geoObj.isRelevant ? res.unshift(geoObj) : res.push(geoObj);
                    }
                }
                return res;
            }
        };

        var destroyMap = function() {
            if (myMap) {
                myMap.destroy();
                myMap = undefined;
            }
        };

        return {
            ready: function(callback) {
                ymaps.ready(callback)
            },

            searchKnown: function (text, callback) {
                var params = {
                    url: suggestionsURL,
                    data: {
                        title: text
                    },
                    dataType: 'json'
                };

                $.ajax(params)
                    .done(function(data) { return callback(data); })
                    .always(function(data) { });
            },

            searchByGeocoder: function (text, callback) {
                return ymaps.geocode(text, {
                    boundedBy: bounds,
                    strictBounds: true,
                    results: 5
                }).then(function (response) { return callback(parser.parse(response)); });
            },

            buildMap: function (location) {
                destroyMap();

                myMap = new ymaps.Map("map", {
                    center: location.coordinates,
                    zoom: 14
                }, {searchControlProvider: "yandex#search"});

                var myPlacemark = new ymaps.Placemark(location.coordinates, {
                    balloonContent: location.addressLine
                });

                myMap.controls.add(new ymaps.control.ZoomControl());
                myMap.geoObjects.add(myPlacemark);

                return myMap;
            },

            destroyMap: destroyMap
        };
    }();
})();
