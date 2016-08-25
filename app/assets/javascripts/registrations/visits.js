$(document).ready(function () {
  "use strict";

  var $chekboxes = $(".icheckbox");

  var options = {
    item: '<li></li>',
    valueNames: [
      {name: 'id', attr: 'data-id'},
      'name'
    ],
    searchColumns: ["name"]
  };

  var registeredList = new List("registered", options);
  var visitedList = new List("visited", options);
  var $registeredCounter = $("#registered_counter");
  var $visitedCounter = $("#visited_counter");

  $chekboxes.iCheck({
    checkboxClass: 'icheckbox_square-blue',
    radioClass: 'iradio_square-blue',
    increaseArea: '20%' // optional
  });

  var moveItemToList = function(item, fromList, toList) {
    $(toList.list).append(item);
    toList.reIndex();
    toList.update();
    fromList.reIndex();
    fromList.update();
  };

  var markVisit = function(checkbox) {
    var $participant = $(checkbox).closest(".participant");
    var userID = $participant.data("id");
    $.ajax({
      url: window.location + "/mark",
      type: "PUT",
      data: {
        user_id: userID,
        visited: checkbox.checked
      },
      success: function() {
        if(!checkbox.checked) {
          moveItemToList($participant.parent(), visitedList, registeredList);
        }
        else {
          moveItemToList($participant.parent(), registeredList, visitedList);
        }
        $registeredCounter.text(registeredList.size());
        $visitedCounter.text(visitedList.size());
      }
    });
  };

  $chekboxes.on("ifChanged", function() {
    markVisit(this);
  });

});