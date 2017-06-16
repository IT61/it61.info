<template>
  <div>
    <label for="" class="required">Настройки мероприятия</label>

    <label class="switch">
      <input name="" type="hidden" value="0">
      <input type="checkbox" v-model='eventSettings.has_attendees_limit' name="" id="event_has_attendees_limit">
      <div class="checkbox"></div>
      <span>Ограничить количество участников</span>
    </label>
  </div>
</template>

<script>
export default {
  props: ['eventSettings'],
  data: function () {
    return {
      
    }
  },
  methods: {
  
  },
  created: function() {
    
  }
}
</script>

