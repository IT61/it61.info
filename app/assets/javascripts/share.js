function shareTo(name) {
  var url;
  var curLocation = window.location.href;
  var height = 300;
  var width = 500;

  switch (name) {
  case 'vk':
    url = 'http://vk.com/share.php?url=' + curLocation + '&title=' + document.title;
    break;
  case 'facebook':
    url = 'https://www.facebook.com/sharer.php?u=' + curLocation;
    break;
  case 'google':
    url = 'https://plus.google.com/share?url=' + curLocation;
    break;
  default:
    return false;
  }

  var top = (screen.height - height) / 2;
  var left = (screen.width - width) / 2;

  window.open(
    url,
    'Рассказать друзьям',
    'width=' + width + ', height=' + height + ', left=' + left + ', top=' + top
  );
}
