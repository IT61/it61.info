/* eslint no-console:0 */
import Vue from 'vue';

import DescriptionComponent from 'components/description';
import FooterComponent from '../components/footer';
import DetailsComponent from '../components/details';
import ImageComponent from '../components/image';
import SettingsComponent from '../components/settings';
import VueResource from 'vue-resource';

Vue.use(VueResource);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '.event-form-container',
    components: {
      DescriptionComponent,
      FooterComponent,
      DetailsComponent,
      ImageComponent,
      SettingsComponent,
    },
    data: {
      dateObj: {},
      eventSettings: {
        title: '',
        link: '',
        cover: '',
        started_at: '',
        description: '',
        place_attributes: {
          id: '',
          title: '',
          address: '',
          latitude: '',
          longitude: '',
        },
        has_attendees_limit: false,
      },
    },
    methods: {
      send() {
        if (this.badValidation())
          return;

        this.dataObjToISO();
        this.$http.post('/events/', { event: this.eventSettings }, {
          headers: {
            'X-CSRF-Token': getToken(),
          }
        }).then(response => {

        }, response => {
          // error callback
        });
      },
      dataObjToISO() {
        this.eventSettings.started_at = this.dateObj.year + '-' +
            this.dateObj.month + '-' + this.dateObj.day + 'T' +
            this.dateObj.hours + ':' + this.dateObj.minutes
      },
      addImageSrc(src) {
        this.eventSettings.cover = src;
      },
      badValidation: function() {
        var errors = [];
        if (!this.eventSettings.title)
          errors.push("название отсутствует")
        if (!this.eventSettings.place_attributes.title)
          errors.push("место проведения отсутствует")
        if (!this.eventSettings.place_attributes.title)
          errors.push("точный адрес отсутствует")
        if (!this.eventSettings.cover)
          errors.push("картинка отсутствует")
        if (!this.eventSettings.cover)
          errors.push("описание отсутствует")

        errors.forEach(function(error) {
          toastr["error"](error);
        })

        return errors.length;
      }
    },
    created() {
      calcTodayDate(this.dateObj);
    },
  })
})

var getToken = function() {
  var token;
  document.querySelectorAll('meta').forEach((i) => {
    if (i.name == 'csrf-token'){
      token = i.content;
      return;
    }
  })
  return token;
}

var calcTodayDate = function(date) {
  var today = new Date();
  var min = today.getMinutes();
  var month = today.getMonth();
  date.day = today.getDate();
  date.month = (month + 1 < 10) ? "0" + (month + 1) : month + 1;
  date.year = today.getFullYear();
  date.hours = today.getHours();
  date.minutes = min < 10 ? '0'+ min : min;
}
