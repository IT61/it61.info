$(document).ready(function () {
  var $imageForm = $('#imageForm'),
    $currentImage = $('#image'),
    $modal = $('#croppedModal'),
    $croppedModalImage = $('#croppedModalImage'),
    $imageInput = $('#imageInput'),
    $uploadImage = $('#uploadImage'),
    $deleteBtn = $('#deleteAvatarBtn');

  if (!$imageForm || !$imageForm.length) {
    return;
  }

  editEventManager.bindDeleteAvatarButton($imageForm, $currentImage, $deleteBtn);
  editEventManager.initCropper($croppedModalImage, $imageInput, $modal, $uploadImage, $imageForm, $currentImage);
});
