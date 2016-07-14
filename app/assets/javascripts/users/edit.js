function bindDeleteAvatarButton($imageForm, userId) {
    var $deleteBtn = $('#delete-avatar-button'),
        $image = $('#image');

    $deleteBtn.on('click', function () {
        deleteAvatar($imageForm, userId);
        $image.attr('src', $image.attr('default_img_src'));
        return false;
    });
}

$(document).ready(function () {
    var $imageForm = $('#image_form'),
        id = $imageForm.attr('user_id'),
        $uploadContainer = $('#avatar_file_upload'),
        $imageInput = $('#avatar_image_input').get(0),
        $image = $('#image');

    if (fileReaderSupported() && $imageInput) {
        showImageOnLoad($imageInput, $image, function() {
            uploadAvatar($imageForm, id);
        });
    }
    if ($uploadContainer.length) {
        handleFileUpload($uploadContainer);
    }
    bindDeleteAvatarButton(id);
});