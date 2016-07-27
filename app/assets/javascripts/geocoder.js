$(document).ready(function () {
    // TODO: Move baseCity to option or anything else
    var baseCity = "Ростов-на-Дону",
        suggestionsURL = "/places/find";

    var $yandexContainer = $('#yandexs-dropdown-container'),
        $oursContainer = $('#ours-dropdown-container'),
        $placeAddress = $('#location'),
        $placeTitle = $('#place_title'),
        $autoPlaceAddress = $('#event_address'),
        $autoPlaceLatitude = $('#event_latitude'),
        $autoEventLongitude = $('#event_longitude'),
        searchLatency = 0.2;

    var model = {
        suggestedLocations: {
            ours: [],
            yandexs: []
        },
        approvedLocations: []
    };

    var controller = {
        clearSuggestions: function() {
            model.suggestedLocations = {ours: [], yandexs: []};
            updateContainer($yandexContainer, model.suggestedLocations.yandexs);
            updateContainer($oursContainer, model.suggestedLocations.ours);
        },
        setYandexSuggestedLocations: function (locations) {
            model.suggestedLocations.yandexs = locations;
            updateContainer($yandexContainer, locations);
        },
        setOursSuggestedLocations: function (locations) {
            model.suggestedLocations.ours = locations;
            updateContainer($oursContainer, locations);
        },
        approveSuggestion: function (location) {
            controller.reset();
            model.approvedLocations.push(location);
            if (location.place_title) {
                $placeTitle.val(location.place_title);
            }
            $placeAddress.val(location.addressLine);
            $placeTitle.trigger('show-input');
            $placeAddress.trigger('show-input');
            buildMap(location);
            $('#map-trigger').show();
            $autoPlaceAddress.val(location.addressLine);
            $autoPlaceLatitude.val(location.coordinates[0]);
            $autoEventLongitude.val(location.coordinates[1]);
        },
        reset: function () {
            model.suggestedLocations = {};
            model.approvedLocations = [];
            destroyMap();
            $('#map-trigger').hide();
            $autoPlaceAddress.val('');
            $autoPlaceLatitude.val('');
            $autoEventLongitude.val('');
        },
        hideContainers: function() {
            updateContainer($yandexContainer, []);
            updateContainer($oursContainer, []);
        }
    };


    var parser = {
        nullifyBaseCity: function(city) {
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
            ].filter(function(n){ return n != undefined }).join(", ");

            var coordinates = object.geometry._coordinates;

            return {
                addressLine: addressLine,
                coordinates: coordinates,
                isRelevant: baseCity === object.getLocalities()[0]
            }
        },
        parseObjects: function (objects, count) {

            res = [];
            for (var i = 0; i < count; i++) {
                var object = objects.get(i);
                if (object !== undefined) {
                    geoObj = parser.parseObject(object);
                    geoObj.isRelevant ? res.unshift(geoObj) : res.push(geoObj);
                }
            }
            return res;
        }
    };

    function updateContainer($container, objects) {
        $container.text('');
        objects.forEach(function (object) {
            label = [
                object.place_title,
                object.addressLine
            ].filter(function (n) { return n != undefined }).join(", ");

            $row = $('<div class="location-suggestion">').text(label);
            $container.append($row);

            $row.on('click', function () {
                controller.approveSuggestion(object);
                controller.clearSuggestions();
            });

        });
    }

    function bindGeocoder() {
        function addressValue() {
            return $placeAddress.val();
        }

        function titleValue() {
            return $placeTitle.val();
        }

        function searchOurs(event) {
            var addressInput = addressValue(),
                titleInput = titleValue();
            if (addressInput.length === 0 && titleInput.length === 0) {
                return;
            }

            $.ajax({
                url: suggestionsURL,
                data: {
                    title: titleInput
                },
                dataType: 'json'
            }).done(function(data) {
                controller.setOursSuggestedLocations(data);
            }).always(function(data) {
            });
        }

        function searchYandex(event) {
            var addressText = addressValue();
            if (addressText.length === 0) {
                return;
            }

            return ymaps.geocode(addressText, {
                boundedBy: [[46.061107, 37.603739], [49.073023, 42.767521]], // todo: add more bounds
                strictBounds: true,
                results: 5
            }).then(function (res) {
                var resultData = parser.parse(res);
                controller.setYandexSuggestedLocations(resultData);
            });
        }

        function defer(func) {
            return function() {
                setTimeout(func, searchLatency);
            }
        }

        $placeAddress.on('input', defer(searchYandex));
        $placeAddress.on('focus', defer(searchYandex));
        $placeTitle.on('input', defer(searchOurs));
        $placeTitle.on('focus', defer(searchOurs));
    }

    $('body').on('click', function () {
        controller.hideContainers();
    });

    ymaps.ready(bindGeocoder);

    var myMap;
    function buildMap(location) {
        destroyMap();

        myMap = new ymaps.Map('map', {
            center: location.coordinates,
            zoom: 14
        }, {
            searchControlProvider: 'yandex#search'
        });

        var myPlacemark = new ymaps.Placemark(location.coordinates, {
            balloonContent: location.addressLine
        });

        myMap.controls.add(
            new ymaps.control.ZoomControl()
        );

        myMap.geoObjects.add(myPlacemark);

        $('.modal-close').first().onclick = function () {
            myMap.destroy();
        };
    }

    function destroyMap() {
        if (myMap) {
            myMap.destroy();
            myMap = undefined;
        }
    }
});
