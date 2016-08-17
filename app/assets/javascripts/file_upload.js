function handleFileUpload($uploadContainer) {
  var wrapper = $uploadContainer,
      inp = wrapper.find('input'),
      btn = wrapper.find('button'),
      lbl = wrapper.find('label');

  btn.focus(function () {
    inp.focus()
  });
  // Crutches for the :focus style:
  inp.focus(function () {
    wrapper.addClass('focus');
  }).blur(function () {
    wrapper.removeClass('focus');
  });

  inp.change(function () {
    if (lbl.is(':visible')) {
      lbl.text('');
      btn.text('Выбрать файл');
    } else {
      lbl.text('');
      btn.text('');
    }
  }).change();

  $(window).resize(function () {
    $uploadContainer.find('input').triggerHandler('change');
  });
}