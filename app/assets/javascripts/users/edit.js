$(document).ready(function () {
  var $imageForm = $('#image-form'),
    $currentImage = $('#image'),
    $modal = $('#cropped-modal'),
    $croppedModalImage = $('#cropped-modal-image'),
    $imageInput = $('#image-input'),
    $uploadImage = $('#upload-image'),
    $deleteBtn = $('#delete-avatar-btn');

  if (!$imageForm || !$imageForm.length) {
    return;
  }

  editEventManager.bindDeleteAvatarButton($imageForm, $currentImage, $deleteBtn);
  editEventManager.initCropper($croppedModalImage, $imageInput, $modal, $uploadImage, $imageForm, $currentImage);
});
