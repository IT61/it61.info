$(document).ready(function () {
  // Мобильная навигация
  if ($(this).width() < 600) {
    var menuToggle = $('#js-mobile-menu').unbind();

    var $activeNavLink = $('li.nav-link.active a');
    if ($activeNavLink.length) {
      menuToggle.find('span').text($activeNavLink.text());
    }

    menuToggle.on('click', function (e) {
      e.preventDefault();
      $('#js-navigation-menu').slideToggle(function () {
        if ($('#js-navigation-menu').is(':hidden')) {
          $('#js-navigation-menu').removeAttr('style');
        }
      });
    });
  }

  window.truncateTitle = function($title, maxLength) {
    if ($title.text().length > maxLength) {
      var title = $title.text().substr(0, maxLength) + '...';
      $title.text(title);
    }
  };

  // Ограничение по длине названия эвента для мобильных девайсов
  // TODO: Переделать с использованием CSS вместо JS
  $('.events-card h2').each(function() {
    truncateTitle($(this), 36);
  });

  // Свайпы в мобильной версии карточек эвентов
  $('.events-card').on('swipeleft', function () {
    $(this).addClass('events-swipe');
  }).on('swiperight', function () {
    $(this).removeClass('events-swipe');
  });
});
