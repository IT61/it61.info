function handleFileUpload() {
    var wrapper = $(".file_upload"),
        inp = wrapper.find("input"),
        btn = wrapper.find("button"),
        lbl = wrapper.find("label");

    btn.focus(function () {
        inp.focus()
    });
    // Crutches for the :focus style:
    inp.focus(function () {
        wrapper.addClass("focus");
    }).blur(function () {
        wrapper.removeClass("focus");
    });

    var file_api = ( window.File && window.FileReader && window.FileList && window.Blob ) ? true : false;

    inp.change(function () {
        var file_name;
        if (file_api && inp[0].files[0])
            file_name = inp[0].files[0].name;
        else
            file_name = inp.val().replace("C:\\fakepath\\", '');

        if (!file_name.length)
            return;

        if (lbl.is(":visible")) {
            lbl.text(file_name);
            btn.text("Выбрать файл");
        } else
            btn.text(file_name);
    }).change();

    $(window).resize(function () {
        $(".file_upload input").triggerHandler("change");
    });
}

function fileReaderSupported() {
    return window.File && window.FileReader && window.FileList && window.Blob
}

function showImageOnLoad() {
    var $imageInput = document.getElementById('image_input'),
        $image = document.getElementById('image');
    if (!$imageInput) {
        return;
    }

    $imageInput.onchange = function () {
        var reader = new FileReader();
        reader.onload = function (e) {
            $image.src = e.target.result;

            if (true) { // todo: refactor and only run this on /users/:id/edit page
                fileAjaxUpload();
            }
        };
        if (this.files.length !== 0) {
            reader.readAsDataURL(this.files[0]);
        }
    };
}

function bindDeleteAvatarButton() {
    var $deleteBtn = $('#delete-avatar-button'),
        $image = $('#image');

    $deleteBtn.on('click', function () {
        fileAjaxDelete();
        $image.attr('src', $image.attr('default_img_src'));
        return false;
    });
}

function fileAjaxDelete() {
    $.ajax({
        url: '/users/1/delete_avatar',
        type: 'GET',
        success: function success() {
        },
        cache: false
    });
}

function fileAjaxUpload() {
    var formData = new FormData($('#image_form')[0]);
    $.ajax({
        url: '/users/1/update_avatar',  // todo: insert id?
        type: 'POST',
        xhr: function () {  // Custom XMLHttpRequest
            var myXhr = $.ajaxSettings.xhr();
            if (myXhr.upload) { // Check if upload property exists
                myXhr.upload.addEventListener('progress', function progressHandlingFunction() {
                }, false); // For handling the progress of the upload
            }
            return myXhr;
        },
        //Ajax events
        beforeSend: function beforeSendHandler() {
        },
        success: function completeHandler() {
        },
        error: function errorHandler() {
        },
        // Form data
        data: formData,
        //Options to tell jQuery not to process data or worry about content-type.
        cache: false,
        contentType: false,
        processData: false
    });
}

$(document).ready(function () {
    var editor = new SimpleMDE({
        element: document.getElementById("editor"),
        autofocus: true,
        forceSync: true
    });

    $('form').bind('submit', function () {
        $(this).find(':input').prop('disabled', false);
    });

    if (fileReaderSupported()) {
        showImageOnLoad();
    }
    handleFileUpload();

    bindDeleteAvatarButton();
});
