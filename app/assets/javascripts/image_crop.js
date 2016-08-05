$(document).ready(function () {

    var $image = $('#uploadedImage');
    var $saveImage = $('#saveImage');
    var $imageForm = $('#image_form');

    // Initialize cropper
    $image.cropper({
        background: false,
        aspectRatio: 1,
        viewMode: 2,
        dragMode: 'move',
        built: function () {
            // Set crop box to most filled part of image by smartcrop
            smartcrop.crop($image[0], {width: 500, height: 500}).then(function (result) {
                $image.cropper('setData', {
                    x: result.topCrop.x,
                    y: result.topCrop.y,
                    width: result.topCrop.width,
                    height: result.topCrop.height,
                    rotate: 0,
                    scaleX: 1,
                    scaleY: 1
                });
            });
            $saveImage.on('click', uploadImageToServer);
        }
    });

    var uploadImageToServer = function() {
        var canvas = $image.cropper('getCroppedCanvas');
        canvas.toBlob(function (blob) {
            var formData = new FormData();
            formData.append('avatar', blob);
            $.ajax($imageForm.data('avatar-path'), {
                method: "POST",
                data: formData,
                processData: false,
                contentType: false,
                xhr: function () {  // Custom XMLHttpRequest
                    var myXhr = $.ajaxSettings.xhr();
                    if (myXhr.upload) { // Check if upload property exists
                        myXhr.upload.addEventListener('progress', function progressHandlingFunction() {
                        }, false); // For handling the progress of the upload
                    }
                    return myXhr;
                },
                success: function () {
                    $('#image').replaceWith($('<div>', {'id': 'image'}).html(canvas));
                },
                error: function () {
                    console.log('Upload error');
                }
            });
        });
    };

});