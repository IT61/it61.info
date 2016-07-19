$(document).ready(function () {
    page = 2;
    $('.load-more').click(function (e) {
        e.preventDefault();
        $.get($(this).attr('href'), {page: page}, function (response) {
            // hide button if no results here
            if(response == '')
            {
                return $(e.currentTarget).css('display', 'none');
            }
            $('.event-container').append(response);
            page++;
        });
    });
});