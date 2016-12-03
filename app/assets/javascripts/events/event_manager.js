var eventManager = {
  initEditor: function () {
    var editorElem = document.getElementById('editor');
    if (editorElem) {
      var editor = new SimpleMDE({
        element: editorElem,
        autofocus: false,
        forceSync: true,
        spellChecker: false
      });
    }
  },

  initCropper: function () {
    var $form = $('.event-form'),
      $imageInput = $('#imageInput'),
      $currentImage = $('#image'),
      $modal = $('#croppedModal'),
      $croppedModalImage = $('#croppedModalImage'),
      $saveImageBtn = $('#uploadImage');

    if (!$form || !$form.length) {
      return;
    }

    $form.bind('submit', function () {
      $(this).find(':input').prop('disabled', false);
    });

    imageImport.bind($croppedModalImage, $imageInput, $modal);
    cropper.create($croppedModalImage, $currentImage, $form);

    $saveImageBtn.on('click', function () {
      var canvas = $('#croppedModalImage').cropper('getCroppedCanvas');
      $('#image').replaceWith($('<div>', {
        'id': 'image'
      }).html(canvas));
    });
  },

  sendFormWithImageBlob: function (form, canvas) {
    canvas.toBlob(function (blob) {
      var formData = new FormData(form);
      formData.append('event[title_image]', blob, "blob.png");
      var request = new XMLHttpRequest();
      request.open(form.method, form.action);
      request.onload = function () {
        response = JSON.parse(request.response);

        if (response.success) {
          window.location = response.url;
        } else {
          toastr['error']("Что-то пошло не так.");
        }
      };
      request.send(formData);
    });
  }
};
