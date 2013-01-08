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
  $("#content").empty();
  post("/dialog/reload.json", {}, function(response) {
    if (response.message) {
      if (response.message.error)
        $("#content").append("<div class='alert-box alert'>" +
          response.message.error +
          "<a href='' class='close'>&times;</a>" +
          "</div>"
        );
      if (response.message.info)
        $("#content").append("<div class='alert-box'>" +
          response.message.info +
          "<a href='' class='close'>&times;</a>" +
          "</div>"
        );
    } else {
      post("/dialog/question.json", {}, function(r) {
        $("#content").append("<p>" + r.data + "</p>");
      });
    }
  });
  return false;
};

var submit = function(e) {
  var last = $("#content").find("p").last();
  var value = $("#value").val();
  last.text(last.text() + " " + value);

  post("/dialog/answer.json", { answer: value }, function(response) {
    $("#content").append("<p>" + response.data.replace(/\n/g, "<br />") + "</p>");
  });

  return false;
};

$(document).ready(function(e){
  $("#submit").click(submit);
  $("#reload").click(reload);
});
