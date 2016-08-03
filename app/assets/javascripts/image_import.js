$(document).ready(function () {

    var $image = $('#uploadedImage');
    var $setImage = $('#set_image');
    var $modal = $('#cropper_modal');

    // Import image to Canvas when $setImage input changed
    var importImage = function () {
        var files = this.files;
        var file;
        if (!$image.data('cropper')) {
            return;
        }

        if (files && files.length) {
            file = files[0];
            if (/^image\/\w+$/.test(file.type)) {
                $modal.prop("checked", true);
                blobURL = URL.createObjectURL(file);
                $image.one('built.cropper', function () {
                    // Revoke when load complete
                    URL.revokeObjectURL(blobURL);
                }).cropper('reset').cropper('replace', blobURL);
                $setImage.val('');
            } else {
                window.alert('Please choose an image file.');
            }
        }
    };

    var URL = window.URL || window.webkitURL;
    var blobURL;
    if (URL) {
        $setImage.change(importImage);
    } else {
        $setImage.prop('disabled', true).parent().addClass('disabled');
    }

});