# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  window.schedule_resize = ->
    win_width = $(window).width()
    box_width = $('.schedule:first').outerWidth()+10
    box_count = Math.floor(win_width/box_width)
    total_width = box_count * box_width
    $('#projects').css 'width',total_width  
  window.schedTimer1 =  ->
    day = $("#hours_popup").data('day')
    week = $("#hours_popup").data('week')
    working = $("#hours_popup").data('working')
    timer1 = $('#hours_popup').data('timerFloat')
    clearInterval(timer1)
    $('#hours_day').text( Math.round(day/36)/100 )
    $('#hours_week').text( Math.round(week/36)/100 )
    if working
      start = new Date
      timer1 = setInterval ->
        $('#hours_day').text(Math.round(((new Date - start)/1000 + day)/36)/100)
        $('#hours_week').text( Math.round(((new Date - start)/1000 + week)/36)/100)
      , 1000
      $('#hours_popup').data('timerFloat',timer1)
  
jQuery ->
  $(".addnew").css "width", $(".schedule:first").outerWidth()
  $(".addnew").css "height", $(".schedule:first").outerHeight()
  $( ".autocomplete" ).autocomplete source: $( ".autocomplete:first" ).data('autocomplete-source')
  $(".datetimepicker").datetimepicker sideBySide: true
  schedTimer1();
  $(window).resize -> 
    schedule_resize()
  schedule_resize()
