$(function () {
  $('body').toggleClass('modal-open', $(this).is(':checked'));

  $('.modal-fade-screen, .modal-close').on('click', function () {
    $('.modal-state:checked').prop('checked', false).change();
  });

  $('.modal-inner').on('click', function (e) {
    e.stopPropagation();
  });
});
