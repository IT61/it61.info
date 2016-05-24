$(document).on('click', '.open-sidebar', () => {
  //$('#mask').remove();
  //$('<div id="mask" class="close-right"></div>').appendTo('.content');
  $('#mask').css({zIndex:100, display:'block'});
  $('.sidebar').animate({
      left: "0"
    }, 100
  );
});
$(document).on('click', '.close-sidebar', () => {
  $('#mask').css({zIndex:0, display:'none'});
  //$('#mask').remove();
  //$('#mask').remove();
  $('.sidebar').animate({
      left: "-300px"
    }, 100
  );
});

