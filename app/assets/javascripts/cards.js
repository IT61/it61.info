$(document).ready(function () {
    // Folding card
    $(".card-fold .btn-fold").click(function () {
        var card = $($(this).parents()[1]);
        var cardBody = card.find(".card-body");
        var btnArrow = $(this).children();

        card.toggleClass("hidden", card.hasClass("hidden"));
        cardBody.toggle();
        btnArrow.toggleClass("icon-arrow-up icon-arrow-down");
    });
});
