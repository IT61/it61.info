// Input float label
$(document).ready(function () {

    $(".input-float-label input, textarea").blur(function () {
        $(this).toggleClass('top-label', this.value !== "");
    }).trigger('blur');

    // Autoresize
    function h(element) {
        $(element).css({'height': 'auto', 'overflow-y': 'hidden'}).height(element.scrollHeight);
    }

    $('textarea').each(function () {
        h(this);
    }).on('input', function () {
        h(this);
    });
});