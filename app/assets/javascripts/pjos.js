var ajax = function(url, data, success, type) {
  $.ajax({
    data: data,
    dataType: "json",
    success: success,
    type: type,
    url: url
  });
};

var get = function(url, data, success) { 
  return ajax(url, data, success, "GET"); 
};

var post = function(url, data, success) {
  return ajax(url, data, success, "POST");
};

var reload = function(e) {
  $("#content").append("<p>Ди нахуй!</p>");
  return false;
};

var submit = function(e) {
  var last = $("#content").find("p").last();
  last.text(last.text() + " Да-да, уже ухожу.");
  return false;
};

$(document).ready(function(e){
  $("#submit").click(submit);
  $("#reload").click(reload);
});
