// Input float label
$(document).ready(function () {

    $(".input-float-label input, textarea").blur(function () {
        $(this).toggleClass('top-label', this.value !== "");
    }).trigger('blur');
});