(function() {
  jQuery(function() {
    var contresize;
    contresize = function() {
      var box_count, box_width, proCount, total_width, win_width;
      win_width = $(window).width();
      proCount = $("#projects").data('count');
      box_width = $('.schedule').outerWidth() + 11;
      box_count = Math.min(Math.floor(win_width / box_width), proCount);
      total_width = box_count * box_width;
      return $('#projects').css('width', total_width);
    };
    $(window).resize(function() {
      return window.contresize();
    });
    $('#modalSignUp').modal('show');
    return $("#sign-up-link").click(function() {
      return $("#sign-up-form").slideToggle();
    });
  });

}).call(this);

