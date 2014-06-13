# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  contresize = ->
    win_width = $(window).width()
    proCount = $("#projects").data('count')
    box_width = $('.schedule').outerWidth()+11;
    box_count = Math.min(Math.floor(win_width/box_width),proCount);
    total_width = box_count * box_width;
    $('#projects').css('width',total_width)
  $(window).resize -> window.contresize()
  $('#modalSignUp').modal('show')
