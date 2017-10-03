<template>
  <div class="register-footer">
    <div class="required-fields">* Поля, обязательные для заполнения</div>
    <div class="buttons event-form-buttons">
      <a class="btn btn-shadow btn-gray" href="/events">Отмена</a>
      <a @click='sendEvent' class="btn btn-shadow btn-blue" id="create-event-button">Сохранить</a>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    sendEvent: function() {
      this.$emit('send-event');
    }
  }
}
</script>
