$(document).ready(function () {
  newEventManager.initEditor();
  newEventManager.initCropper();
  initFileInput($('#imageInputContainer'));
});

function onSubmitEventCreate() {
  var $croppedModalImage = $('#croppedModalImage'),
      form = $('form#new_event')[0],
      canvas = $croppedModalImage.cropper('getCroppedCanvas');

  newEventManager.uploadFormWithImageBlob(form, canvas);
  return false;
}