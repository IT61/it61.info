$(document).ready(function () {

    var $yandexContainer = $('#yandexs-dropdown-container'),
        $oursContainer = $('#ours-dropdown-container');


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
            // sync hidden fields
            $('#event_address').val(location.meta.text);
            $('#event_latitude').val(location.coordinates[0]);
            $('#event_longitude').val(location.coordinates[1]);
        },
        reset: function () {
            model.suggestedLocations = {};
            model.approvedLocations = [];
            // clear hidden fields
            $('#event_address').val('');
            $('#event_latitude').val('');
            $('#event_longitude').val('');
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
        var addressInput = $('#location'),
            titleInput = $('#place_title');

        function addressValue() {
            return addressInput.val();
        }

        function titleValue() {
            return titleInput.val();
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
                dataType: 'application/json'
            }).then(function(data) {
                // debugger;
                console.log('success response: ' + data);
                controller.setOursSuggestedLocations(data);
            });
        }

        function searchYandex(event) {
            var addressText = addressValue();
            if (addressText.length === 0) {
                return;
            }

            ymaps.geocode(addressText, {
                boundedBy: [[46.061107, 37.603739], [49.073023, 42.767521]], // todo: add more bounds
                strictBounds: true,
                results: 5
            }).then(function (res) {
                var resultData = parser.parse(res);
                controller.setYandexSuggestedLocations(resultData);
            });
        }

        // we search in our database by title and address
        // we search in yandex only by address
        addressInput.on('input', searchYandex);
        addressInput.on('focus', searchYandex);
        addressInput.on('input', searchOurs);
        addressInput.on('focus', searchOurs);
        titleInput.on('input', searchOurs);
        titleInput.on('focus', searchOurs);
    }

    $('body').on('click', function () {
        controller.setYandexSuggestedLocations([]);
        controller.setOursSuggestedLocations([]);
    });

    ymaps.ready(bindGeocoder);
});
