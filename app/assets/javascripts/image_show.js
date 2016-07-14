function fileReaderSupported() {
    return window.File && window.FileReader && window.FileList && window.Blob
}

function showImageOnLoad($imageInput, $image, onLoadCallback) {
    if (!$imageInput) {
        return;
    }

    $imageInput.onchange = function () {
        var reader = new FileReader();
        reader.onload = function (e) {
            $image.attr('src', e.target.result);
            if (onLoadCallback)
                onLoadCallback();
        };
        if (this.files.length !== 0) {
            reader.readAsDataURL(this.files[0]);
        }
    };
}