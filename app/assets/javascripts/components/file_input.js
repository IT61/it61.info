function initFileInput($uploadContainer) {
  var wrapper = $uploadContainer,
      input = wrapper.find('input'),
      button = wrapper.find('button'),
      label = wrapper.find('label');

  button.focus(function () {
    input.focus()
  });
  // Crutches for the :focus style:
  input.focus(function () {
    wrapper.addClass('focus');
  }).blur(function () {
    wrapper.removeClass('focus');
  });

  $(window).resize(function () {
    $uploadContainer.find('input').triggerHandler('change');
  });
}