$(document).ready(function () {
    $('.open-sidebar').click(function () {
        $('#mask').css({zIndex:100, display:'block'});
        $('.sidebar').animate({left: "0"}, 100);
    });

    $('.close-sidebar').click(function () {
        $('#mask').css({zIndex:0, display:'none'});
        $('.sidebar').animate({left: "-300px"}, 100);
    });
});