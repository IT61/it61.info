$(document).ready(function () {
  page = 1;

  function loadNextPage(onItemsAppended) {
    var $btn = $(this);
    var url = $btn.data('url');
    var container = $btn.data('container');
    page++;
    $.get(url, {page: page}, function (response) {

      // hide button if no results here
      if (response == '') {
        return $btn.css('display', 'none');
      }
      $(container).append(response);
      if ($.isFunction(onItemsAppended))
        onItemsAppended();
    });
  }

  $("#users_more").click(loadNextPage);
  $("#events_more").click(function () {
    loadNextPage.call(this, function () {
      $(".events-card h2").each(function () {
        truncateTitle($(this), 36);
      });
      $('.dropdown-button').dropdown();
    })
  });

});