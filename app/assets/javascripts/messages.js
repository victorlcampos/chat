jQuery(document).ready(function() {
  var source = new EventSource('/messages/subscription');
  var message;

  source.addEventListener('messages.create', function (e) {
    message = JSON.parse(e.data);
    $("#messages").append($('<li>').text(message.name + ': ' + message.content));
  });
});