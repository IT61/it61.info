// Input float label
$(document).ready(function () {

  var $input = $(".input-float-label input, textarea");

  $input.on('blur show-input', function () {
    $(this).toggleClass('top-label', this.value !== "");
  }).trigger('show-input');

  // Autoresize textarea
  function h(element) {
    $(element).css({'height': 'auto', 'overflow-y': 'hidden'}).height(element.scrollHeight);
  }

  $('textarea').each(function () {
    h(this);
  }).on('input', function () {
    h(this);
  });
});
