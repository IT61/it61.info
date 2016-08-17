$(document).ready(function () {

  var editorElem = document.getElementById('editor');
  if (editorElem) {
    var editor = new SimpleMDE({
      element: editorElem,
      autofocus: false,
      forceSync: true,
      spellChecker: false
    });
  }

  var $form = $('form#new_event'),
      $imageInput = $('#imageInput'),
      $currentImage = $('#image'),
      $modal = $('#croppedModal'),
      $croppedModalImage = $('#croppedModalImage'),
      $uploadImage = $('#uploadImage');

  if (!$form || !$form.length) {
    return;
  }

  $form.bind('submit', function () {
    $(this).find(':input').prop('disabled', false);
  });

  imageImport.bind($croppedModalImage, $imageInput, $modal);
  cropper.create($croppedModalImage, $currentImage, $uploadImage, $form);
});