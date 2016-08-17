$(document).ready(function () {
  page = 1;

  function loadNextPage(e) {
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
    });
  }

  $('.btn-more').click(loadNextPage);
});