var imageImport = (function () {
  // Import image to Canvas when $setImage input changed
  var importImage = function ($croppedModalImage, $imageInput, $modal) {
    var files = $imageInput[0].files;
    var file;
    if (!$croppedModalImage.data('cropper')) {
      return;
    }
    if (files && files.length) {
      file = files[0];
      if (/^image\/[\w+]+$/.test(file.type)) {
        $modal.prop("checked", true);
        blobURL = URL.createObjectURL(file);
        $croppedModalImage.one('built.cropper', function () {
          // Revoke when load complete
          URL.revokeObjectURL(blobURL);
        }).cropper('reset').cropper('replace', blobURL);
        $imageInput.val('');
      } else {
        window.alert('Please choose an image file.');
      }
    }
  };

  var bindImageImport = function ($croppedModalImage, $imageInput, $modal) {
    var URL = window.URL || window.webkitURL;
    if (URL) {
      $imageInput.change(function () {
        importImage($croppedModalImage, $imageInput, $modal)
      });
    } else {
      $imageInput.prop('disabled', true).parent().addClass('disabled');
    }
  };

  return {
    bind: bindImageImport
  };
})();
