var DocumentProcessor = (function() {
  var jobId = null,
      docId = null;

  function _init(id, doc_id) {
    jobId = id;
    docId = doc_id;
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

        if ($(element).text() != '100%') {
          setTimeout(_getProgress(element), 1500);
        } else {
          window.location.replace('/documents/' + docId);
        }
      }
    });

  }

  return { init: _init };
})();

$(function() {

  $('.download').hide();

  $('.go').on('click', function() {

    $('.overlay').fadeOut(500);
    $('.download').fadeIn(500);
  });
});