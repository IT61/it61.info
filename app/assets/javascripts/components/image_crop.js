var cropper = (function () {

  var createCropper = function ($croppedModalImage, $currentImage, $form, onCropperCreated) {
    $croppedModalImage.cropper({
      background: false,
      aspectRatio: 1,
      viewMode: 2,
      dragMode: 'move',
      built: function () {
        // Set crop box to most filled part of image by smartcrop
        smartcrop.crop($croppedModalImage[0], {width: 500, height: 500}).then(function (result) {
          $croppedModalImage.cropper('setData', {
            x: result.topCrop.x,
            y: result.topCrop.y,
            width: result.topCrop.width,
            height: result.topCrop.height,
            rotate: 0,
            scaleX: 1,
            scaleY: 1
          });
        });

        if (onCropperCreated) {
          onCropperCreated();
        }
      }
    });
  };

  return {
    create: createCropper
  }
})();
