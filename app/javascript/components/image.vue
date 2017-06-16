<template>
  <div class="image-container">
    <label class="required" for="event_cover">Изображение</label>
    <img v-if="!!src" class="image" :src='src' alt="">
    <div v-if='!src' class="no-image-selected" id="image">
      <div class="message">Файл не выбран</div>
    </div>
    <div class="file_upload" id="image-input-container" style="max-width: 300px;">
      <vue-core-image-upload
        class='btn btn-blue btn-new-image'
        :crop-ratio="'1:1'"
        :crop="'local'"
        :text="'Выберите файл'"
        :cropBtn="cropBtn"
        @imagechanged="imagechanged"
        @imageuploading="imageuploading"
        :max-file-size="5242880"
        url="http://101.198.151.190/api/upload.php" >
      </vue-core-image-upload>
    </div>
  </div>
</template>

<script>
import VueCoreImageUpload from 'vue-core-image-upload'

export default {
  data() {
    return {  
      src: '',
      cropBtn: {
        ok: 'ok',
        cancel:'Отмена'
      }
    }
  },
  methods: {
    imagechanged(res) {
      this.src = res;
      this.$emit('add-image-src', res);
    },
    imageuploading(){
      this.showPreload = true;
    }
  },
  components: {
    VueCoreImageUpload,
  },
  created: function() {

  }
};
</script>

<style>

</style>
