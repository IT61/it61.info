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
      $imageInput = $('#image-input'),
      $currentImage = $('#image'),
      $modal = $('#cropped-modal'),
      $croppedModalImage = $('#cropped-modal-image'),
      $saveImageBtn = $('#upload-image');

    if (!$form || !$form.length) {
      return;
    }

    $form.bind('submit', function () {
      $(this).find(':input').prop('disabled', false);
    });

    imageImport.bind($croppedModalImage, $imageInput, $modal);
    cropper.create($croppedModalImage, $currentImage, $form);

    $saveImageBtn.on('click', function () {
      var canvas = $('#cropped-modal-image').cropper('getCroppedCanvas');
      $('#image').replaceWith($('<div>', {
        'id': 'image'
      }).html(canvas));
    });
  },

  sendFormWithImageBlob: function (form, canvas) {
    var poster = canvas.toDataURL().replace(/^data:image\/(png|jpg);base64,/, ''),
      postData = $(form).serializeObject();

    postData['event[cover]'] = poster;

    $.ajax({
      url: '/events',
      dataType: 'json',
      data: postData,
      method: 'POST'
    }).fail(function (response) {
      toastr['error'](response.responseText);
    });
  }
};
