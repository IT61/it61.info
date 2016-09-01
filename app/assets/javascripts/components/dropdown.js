$(document).ready(function () {
  $(".dropdown-trigger").click(function (e) {
    $(this).toggleClass("open");
    e.stopPropagation();
  });

  $(document).click(function () {
    $(".dropdown-trigger.open").removeClass("open");
  })
});
