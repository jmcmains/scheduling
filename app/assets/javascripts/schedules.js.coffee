# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  window.update_sched = -> 
    $( ".autocomplete" ).autocomplete source: $(".schedule_time:first").data 'autocomplete-source'
    $(".datetimepicker").datetimepicker sideBySide: true
  window.contresize = ->
    win_width = $(window).width()
    box_width = $('.schedule_time:first').outerWidth()+10
    box_count = Math.floor(win_width/box_width)
    total_width = box_count * box_width
    $('#projects').css 'width',total_width
  $(".addnew").css "width", $(".schedule_time:first").width()
  $(".addnew").css "height", $(".schedule_time:first").height()
  window.contresize()
  window.update_sched()
  $(window).resize -> window.contresize()