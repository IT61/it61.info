<template>
  <div class="details-container">
    <div class="event-association-field">
      <div class="input-float-label">
        <input type="text"
          v-model='eventSettings.title'>
        <label>Название</label>
      </div>
    </div>
    <div class="time-container">
      <div class="time-select">
        <label class="required">Дата начала</label>
        <select v-model='dateObj.day'>
          <option v-for='day in datetime.days' :value='day'>{{day}}</option>
        </select>
        <select v-model='dateObj.month'>
          <option v-for='(month, index) in datetime.months' :value='setMonthValueAttr(index + 1)'>{{month}}</option>
        </select>
        <select v-model='dateObj.year'>
          <option v-for='year in datetime.years' :value='year'>{{year}}</option>
        </select>
      </div>
      <div class="time-select">
        <label class="required">Время начала</label>
        <select v-model='dateObj.hours'>
          <option v-for='hour in datetime.hours' :value="hour">{{hour}}</option>
        </select>
        <span class="time-separator">:</span>
        <select v-model='dateObj.minutes'>
          <option v-for='minute in datetime.minutes' :value='minute'>{{minute}}</option>
        </select>
      </div>
    </div>
    <div class="event-association-field">
      <div class="input-float-label">
        <input class="autocomplete-input" type="text"
          v-model='eventSettings.link'>
        <label>Ссылка на сторонний сайт</label>
      </div>
    </div>
    <div class="event-association-field">
      <div class="input-float-label">
        <input class="autocomplete-input" 
          autocomplete="off" type="text" 
          @input='getOurs' 
          v-model='eventSettings.place_attributes.title'
          @blur='resetLists'>
        <ul class="autocomplete-container" 
            v-if='model.ours.length && eventSettings.place_attributes.title.length'>
          <li class="autocomplete-container-item"
            v-for='place in model.ours'
            @click='setOursFromList(place)'>{{place.place_title + ', ' + place.addressLine}}</li>
        </ul>
        <label>Место проведения</label>
      </div>
    </div>
    <div class="event-association-field">
      <div class="input-float-label">
        <input class="autocomplete-input"  id="yandex-input" 
          autocomplete="off" type="text" 
          @input='getYandex' 
          v-model='eventSettings.place_attributes.address'
          @blur='resetLists'>  
        <ul class="autocomplete-container" 
          v-if='model.yandex.length'>
          <li class="autocomplete-container-item" 
            v-for='place in model.yandex'
            @click='setYandexFromList(place)'>{{place.addressLine}}</li>
        </ul>
        <label>Точный адрес</label>
      </div>
    </div>
    <div class="modal">
      <label for="modal-1">
        <a class="btn btn-gray modal-trigger" v-if='map' id="">Посмотреть на карте</a>
      </label>
      <input class="modal-state" id="modal-1" type="checkbox">
      <div class="modal-fade-screen">
        <div class="modal-inner">
          <div class="modal-content">
            <div class="header">
              <h2>Карта</h2>
            </div>
            <div id="map">
            </div>
          </div>
          <div class="btn modal-close" for="modal-1">Закрыть</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['eventSettings', 'dateObj'],
  data: function () {
    return {
      datetime:{
        days: [],
        months: [ 'января', 'февраля', 'марта', 'апреля', 'мая', 
                  'июня', 'июля', 'августа', 'сентября', 'октября',
                   'ноября', 'декабря' ],
        years: ['2017','2018','2019'],
        hours: [],
        minutes: [],
      },
      model:{
        ours: [],
        yandex: []
      },
      map: 0,
    }
  },
  methods: {
    getYandex: function () {
        var text = event.target.value, self = this,
            bounds = [[46.061107, 37.603739], [49.073023, 42.767521]];
             
        return ymaps.geocode(text, {
          boundedBy: bounds,
          strictBounds: true,
          results: 5
        }).then(function (response) {
          self.model.yandex = parser.parse(response);
        });
    },
    getOurs: function() { 
      var self = this;
      $.ajax({
        url: 'http://localhost:3000/places/find?title=' + self.eventSettings.place_attributes.title,
        success: function(res){
          self.model.ours = res;
        }
      });  
    },
    setOursFromList: function(place) {
      this.eventSettings.place_attributes.id = place.id;
      this.eventSettings.place_attributes.title = place.place_title;
      this.eventSettings.place_attributes.address = place.addressLine;
      this.eventSettings.place_attributes.latitude = place.coordinates[0];
      this.eventSettings.place_attributes.longitude = place.coordinates[1];
      document.querySelector('#yandex-input').focus(); //костыль для добавления второго адреса
      this.map = Geocoder.buildMap('map', this.eventSettings.place_attributes);
    },
    setYandexFromList: function(place) {
      this.eventSettings.place_attributes.address = place.addressLine;
      this.eventSettings.place_attributes.latitude = place.coordinates[0];
      this.eventSettings.place_attributes.longitude = place.coordinates[1];
      this.map = Geocoder.buildMap('map', this.eventSettings.place_attributes);
    },
    resetLists: function() {
      return setTimeout(() => { 
        this.model.ours = [];
        this.model.yandex = [];
      }, 100)
    },
    setMonthValueAttr(index){
      return (index < 10) ? "0" + (index) : index
    }
  },
  created: function() {
    setDataParams(this.datetime);
  }
}


function setDataParams(datetime) {
  for (var iterator = 0; iterator != 60; iterator++){
    if (iterator <= 23) 
      datetime.hours.push(
        iterator < 10 ? '0' + iterator : iterator.toString()
      );
    if (iterator > 0 && iterator <= 31) 
      datetime.days.push(iterator.toString());

    datetime.minutes.push(
      iterator < 10 ? '0' + iterator : iterator.toString()
    );
  }
}

var parser = {
  parse: function (rawData) {
    var objects = rawData.geoObjects,
        count = rawData.metaData.geocoder.results;
    return parser.parseObjects(objects, count);
  },
  parseObject: function (object) {
    var addressLine = [
      object.getLocalities()[0],
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
    }
  },
  parseObjects: function (objects, count) {
    var res = [];
    for (var i = 0; i < count; i++) {
      var object = objects.get(i);
      if (object !== undefined) {
        var geoObj = parser.parseObject(object);
        res.push(geoObj);
      }
    }
    return res;
  }
};


</script>

