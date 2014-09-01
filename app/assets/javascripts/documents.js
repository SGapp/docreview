var DocumentProcessor = (function() {
  var jobId = null;

  function _init(id) {
    jobId = id;

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
        }

      }
    });

  }

  return { init: _init };
})();

$(function() {

  $('.go').on('click', function() {

    $('.overlay').fadeOut(500);
  });
});