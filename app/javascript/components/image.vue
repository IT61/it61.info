<template>
  <div class="image-container">
      <label class="required">Изображение</label>
    <vue-image-cropper
      :cropOptions="cropOptions"
      :locales="locales"
      @cropped="imageCropped">
    </vue-image-cropper>
  </div>
</template>

<script>
import VueImageCropper from 'vue-image-cropper';

export default {
  components: {
    VueImageCropper
  },
  data() {
    return {
      cropOptions: {
        aspectRatio: '1:1',
        height: 300,
        width: 300
      },
      locales: {
        title: 'Файл не выбран',
        cancel: 'Отмена',
        confirm: 'Сохранить'
      }
    }
  },
  methods: {
    imageCropped(image) {
      // TODO: Upload to server
    }
  }
};
</script>
