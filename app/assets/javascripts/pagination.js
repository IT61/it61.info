$(document).ready(function () {
    page = 2;

    function loadNextPage(e) {
        var $btn = $(this);
        var url = $btn.data('url');
        var container = $btn.data('container');
        $.get(url, {page: page}, function (response) {
            // hide button if no results here
            if(response == '')
            {
                return $btn.css('display', 'none');
            }
            $(container).append(response);
            page++;
        });
    }

    $('.btn-more').click(loadNextPage);
});