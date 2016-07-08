// Input float label
$(document).ready(function () {
    $(".input-float-label input").blur(function () {
        if (this.value !== "") {
            $(this).addClass('top-label');
        } else {
            $(this).removeClass('top-label');
        }
    });
});
