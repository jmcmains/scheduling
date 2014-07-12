(function() {
  jQuery(function() {
    $('#now').change(function() {
      $("#now-text-field").toggle();
    });
    window.contresize = function() {
      var box_count, box_width, proCount, total_width, win_width;
      win_width = $(window).width();
      proCount = $("#projects").data('count');
      box_width = $('.project').outerWidth() + 11;
      box_count = Math.min(Math.floor(win_width / box_width), proCount);
      total_width = box_count * box_width;
      $('#projects').css('width', total_width);
    };
    window.schedTimer = function() {
      var day, start, timer1, week, working;
      day = $("#hours_popup").data('day');
      week = $("#hours_popup").data('week');
      working = $("#hours_popup").data('working');
      timer1 = $('#hours_popup').data('timerFloat');
      clearInterval(timer1);
      $('#hours_day').text(Math.round(day / 36) / 100);
      $('#hours_week').text(Math.round(week / 36) / 100);
      if (working) {
        start = new Date;
        timer1 = setInterval(function() {
          $('#hours_day').text(Math.round(((new Date - start) / 1000 + day) / 36) / 100);
          $('#hours_week').text(Math.round(((new Date - start) / 1000 + week) / 36) / 100);
        }, 1000);
        $('#hours_popup').data('timerFloat', timer1);
      }
    };
    schedTimer();
    contresize();
    $(".autocomplete-project").autocomplete({
      source: $("#name").data('autocomplete-source')
    });
    $(".datepicker-no-time").datetimepicker({
      pickTime: false
    });
    $(".datepicker-no-time").on("blur", function(e) {
      $(this).datepicker("hide");
    });
    $(window).resize(function() {
      return window.contresize();
    });
    return $("#hours_popup").click(function() {
      if ($("#hours_popup").hasClass("hidden1")) {
        $("#hours").slideToggle("slow");
        $("#hours_popup").removeClass("hidden1");
        $("#hours_popup").addClass("shown1");
      } else {
        $("#hours").slideToggle("slow");
        $("#hours_popup").addClass("hidden1");
        $("#hours_popup").removeClass("shown1");
      }
    });
  });

}).call(this);

