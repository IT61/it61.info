$(document).ready(function () {
  $('.btn-fab').click(function () {
    if ($('.btn-fab.child').is(':visible')) {
      $('.btn-fab.child').stop().animate({
        top: $(this).css('top'),
        opacity: 0
      }, 125, function () {
        $(this).hide();
      });
    } else {
      $('.btn-fab.child').each(function () {
        $(this)
          .stop()
          .show()
          .animate({
            top: parseInt($(this).height() + 50 * $(this).data('subitem')) + 'px',
            opacity: 1
          }, 125);
      });
    }
  });
});
