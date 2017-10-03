$.fn.serializeObject = function () {
  var o = {};
  var a = this.serializeArray();
  $.each(a, function () {
    if (o[this.name] !== undefined) {
      if (!o[this.name].push) {
        o[this.name] = [o[this.name]];
      }
      o[this.name].push(this.value || '');
    } else {
      o[this.name] = this.value || '';
    }
  });
  return o;
};

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
    var poster = null;

    if ($.isFunction(canvas.toDataURL)) {
      poster = canvas.toDataURL();
    }
    var postData = $(form).serializeObject(),
      eventId = $('#event_id').val();

    postData['event[cover]'] = poster;

    $.ajax({
      url: eventId === '' ? '/events' : '/events/' + eventId,
      dataType: 'json',
      data: postData,
      method: 'POST',
    }).fail(function (response) {
      if (!response) return;

      if (response.status != 200 && response.responseJSON.errors) {
        var errors = response.responseJSON.errors;
        $.map(errors, toastr['error']);
      } else if (response.status == 302) {
        window.location.replace(response.responseJSON.eventPath);
      }
    }).done(function() {
      toastr.success('Мероприятие успешно обновлено!');
    });
  }
};
