$(document).ready(function () {

    var $yandexContainer = $('#yandexs-dropdown-container'),
        $oursContainer = $('#ours-dropdown-container'),
        $placeAddress = $('#location'),
        $placeTitle = $('#place_title'),
        $autoPlaceAddress = $('#event_address'),
        $autoPlaceLatitude = $('#event_latitude'),
        $autoEventLongitude = $('#event_longitude');

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
            // debugger;
        },
        approveSuggestion: function (location) {
            controller.reset();
            model.approvedLocations.push(location);
            if (location.place_title) {
                $placeTitle.val(location.place_title);
            }
            // fill input
            $placeAddress.val(location.meta.text);
            $placeTitle.trigger('show-input');
            // sync hidden fields
            $autoPlaceAddress.val(location.meta.text);
            $autoPlaceLatitude.val(location.coordinates[0]);
            $autoEventLongitude.val(location.coordinates[1]);
        },
        reset: function () {
            model.suggestedLocations = {};
            model.approvedLocations = [];
            // clear hidden fields
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
        parse: function (rawData) {
            var objects = rawData.geoObjects,
                count = rawData.metaData.geocoder.results;
            return parser.parseObjects(objects, count);
        },
        parseObject: function (object) {
            var metaData = object.properties.get('metaDataProperty').GeocoderMetaData,
                coordinates = object.geometry._coordinates;
            return {
                meta: metaData,
                coordinates: coordinates
            }
        },
        parseObjects: function (objects, count) {
            res = [];
            for (var i = 0; i < count; i++) {
                var object = objects.get(i);
                if (object !== null) {
                    res.push(parser.parseObject(object));
                }
            }
            return res;
        }
    };

    function updateContainer($container, objects) {
        $container.text('');
        objects.forEach(function (object) {
            $row = $('<div class="location-suggestion">').text(object.meta.text);
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
                url: '/events/places',
                data: {
                    title: titleInput,
                    address: addressInput
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
                setTimeout(func, 0);
            }
        }

        // we search in our database by title and address
        // we search in yandex only by address
        $placeAddress.on('input', defer(searchYandex));
        $placeAddress.on('focus', defer(searchYandex));
        $placeAddress.on('input', defer(searchOurs));
        $placeAddress.on('focus', defer(searchOurs));

        $placeTitle.on('input', searchOurs);
        $placeTitle.on('focus', searchOurs);
    }

    $('body').on('click', function () {
        controller.hideContainers();
    });

    ymaps.ready(bindGeocoder);
});
