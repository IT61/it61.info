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
    var poster = null;

    if ($.isFunction(canvas.toDataURL)) {
      poster = canvas.toDataURL();
    }
    var postData = $(form).serializeObject();

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
