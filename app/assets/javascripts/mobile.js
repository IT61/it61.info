$(document).ready(function () {
  // Мобильная навигация
  if ($(this).width() < 600) {
    var menuToggle = $('#js-mobile-menu').unbind();

    menuToggle.find("span").text($("li.nav-link.active a").text());

    menuToggle.on('click', function (e) {
      e.preventDefault();
      $('#js-navigation-menu').slideToggle(function () {
        if ($('#js-navigation-menu').is(':hidden')) {
          $('#js-navigation-menu').removeAttr('style');
        }
      });
    });
  }

  // Ограничение по длине названия эвента для мобильных девайсов
  // TODO: Переделать с использованием CSS вместо JS
  $(".events-card h2").each(function () {
    if ($(this).text().length > 36) {
      var title = $(this).text().substr(0, 36) + "...";
      $(this).text(title);
    }
  });

  // Свайпы в мобильной версии карточек эвентов
  $(".events-card").on("swipeleft", function () {
    $(this).addClass("events-swipe");
  }).on("swiperight", function () {
    $(this).removeClass("events-swipe");
  });
});