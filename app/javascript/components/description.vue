<template>
  <div>
    <vue-editor
     v-model='eventSettings.description'></vue-editor>
  </div>
</template>

<script>
  import { VueEditor } from 'vue2-editor'

  export default {
    components: {
      VueEditor
    },
    props: ['eventSettings'],
  }
</script>