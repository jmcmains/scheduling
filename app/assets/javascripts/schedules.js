(function() {
  jQuery(function() {
  	$(".addnew").css("width", $(".schedule:first").outerWidth());
    $(".addnew").css("height", $(".schedule:first").outerHeight());
    $(".autocomplete").autocomplete({
      source: $(".autocomplete:first").data('autocomplete-source')
    });
    $(".datetimepicker").datetimepicker({
      sideBySide: true
    });

    window.schedule_resize = function() {
      var box_count, box_width, total_width, win_width;
      win_width = $(window).width();
      box_width = $('.schedule:first').outerWidth() + 10;
      box_count = Math.floor(win_width / box_width);
      total_width = box_count * box_width;
      $('#projects').css('width', total_width);
      if (win_width < 575) {
        $('#calendar').fullCalendar('changeView', 'agendaDay');
      } else {
        $('#calendar').fullCalendar('changeView', 'agendaWeek');
      }
    };
    window.schedTimer1 = function() {
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
    $(window).resize(function() {
      window.schedule_resize();
    });
    window.schedTimer1();
    window.schedule_resize();
  });


}).call(this);

