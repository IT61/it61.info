function bindDeleteAvatarButton($imageForm, $image, $deleteBtn) {
  $deleteBtn.on('click', function () {
    deleteAvatar($imageForm);
    $image.attr('src', $image.attr('default_img_src'));
    return false;
  });
}

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

  // bindDeleteAvatarButton($imageForm, $image, $deleteBtn); // todo: make it work!
  imageImport.bind($croppedModalImage, $imageInput, $modal);
  cropper.create($croppedModalImage, $currentImage, $uploadImage, $imageForm);
});