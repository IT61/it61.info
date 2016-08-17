var cropper = (function () {
  var createCropper = function ($croppedModalImage, $currentImage, $saveImageBtn, $form) {
    // Initialize cropper
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
        $saveImageBtn.on('click', function () {
          uploadImageToServer($croppedModalImage, $currentImage, $form)
        });
      }
    });
  };

  var uploadImageToServer = function ($croppedModalImage, $currentImage, $form) {
    var canvas = $croppedModalImage.cropper('getCroppedCanvas');
    canvas.toBlob(function (blob) {
      var formData = new FormData(); // todo: check if works as intented
      formData.append('avatar', blob);
      $.ajax($form.data('avatar-path'), {
        method: "POST",
        data: formData,
        processData: false,
        contentType: false,
        xhr: function () {  // Custom XMLHttpRequest
          var myXhr = $.ajaxSettings.xhr();
          if (myXhr.upload) { // Check if upload property exists
            myXhr.upload.addEventListener('progress', function progressHandlingFunction() {
            }, false); // For handling the progress of the upload
          }
          return myXhr;
        },
        success: function () {
          $currentImage.replaceWith($('<div>', {'id': 'image'}).html(canvas));
        },
        error: function () {
          console.log('Upload error');
        }
      });
    });
  };

  // todo: get rid of copypaste!
  var uploadFullFormToServer = function ($croppedModalImage, $currentImage, $form) {
    var canvas = $croppedModalImage.cropper('getCroppedCanvas');
    canvas.toBlob(function (blob) {
      var formData = new FormData($form[0]); // todo: check if works as intented
      formData.append('avatar', blob);
      $.ajax($form.data('avatar-path'), {
        method: "POST",
        data: formData,
        processData: false,
        contentType: false,
        xhr: function () {  // Custom XMLHttpRequest
          var myXhr = $.ajaxSettings.xhr();
          if (myXhr.upload) { // Check if upload property exists
            myXhr.upload.addEventListener('progress', function progressHandlingFunction() {
            }, false); // For handling the progress of the upload
          }
          return myXhr;
        },
        success: function () {
          $currentImage.replaceWith($('<div>', {'id': 'image'}).html(canvas));
        },
        error: function () {
          console.log('Upload error');
        }
      });
    });
  };

  return {
    create: createCropper
  }
})();
