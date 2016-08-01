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

    var $uploadContainer = $('#event_file_upload'),
        $form = $('form#new_event'),
        $imageInput = $('#event_image_input').get(0),
        $image = $('#image');

    $form.bind('submit', function () {
        $(this).find(':input').prop('disabled', false);
    });

    if (fileReaderSupported() && $imageInput) {
        showImageOnLoad($imageInput, $image);
    }

    if ($imageInput) {
        handleFileUpload($uploadContainer);
    }
});