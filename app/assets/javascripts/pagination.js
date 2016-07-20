$(document).ready(function () {
    page = 2;

    function loadNextPage(e) {
        var $btn = $(this);
        var url = $btn.data('url');
        var container = $btn.data('container');
        console.log(url, container);
        $.get(url, {page: page}, function (response) {
            // hide button if no results here
            if(response == '')
            {
                console.log('returned');
                return $btn.css('display', 'none');
            }
            $(container).append(response);
            page++;
        });
    }

    $('.btn-more').click(loadNextPage);
});