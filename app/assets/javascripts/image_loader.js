function deleteAvatar(userId) {
    $.ajax({
        url: '/users/' + userId + '/delete_avatar',
        type: 'GET',
        success: function success() {
        },
        cache: false
    });
}

function uploadAvatar($imageForm, userId) {
    var formData = new FormData($imageForm[0]);
    $.ajax({
        url: '/users/' + userId + '/update_avatar',
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