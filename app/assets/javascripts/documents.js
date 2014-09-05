var DocumentProcessor = (function() {
  var jobId = null,
      docId = null;

  function _init(id, doc_id) {
    jobId = id;
    docId = doc_id;
    timer = 0
    return { getProgress: _getProgress };
  }

  function _getProgress(element) {
    $.ajax({
      type: 'GET',
      url: "/jobs/progress/" + jobId,

      success: function(data) {
        percentage = 'width: ' + data['percent'] + '%;';
        $(element).attr('style', percentage).text(data['percent'] + '%');
        $(element).attr('aria-valuenow', data['percent'])

        if ($(element).text() != '100%' && timer < 100) {
          console.log(timer);
          timer = setTimeout(_getProgress(element), 1500);
        } else if (timer >= 100) {
          console.log(timer);
          $('.download').fadeOut(100);
          $('#progress-bar').fadeOut(100);
          $('.failure').fadeIn(300);
        }
        else {
          console.log(timer);
          $('.download').fadeOut(100);
          $('#progress-bar').fadeOut(100);
          $('.button-download').fadeIn(300);
        }
      }
    });

  }

  return { init: _init };
})();

$(function() {

  $('.button-download').hide();
  $('.failure').hide();

})




