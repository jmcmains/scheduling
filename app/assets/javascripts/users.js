(function() {
  jQuery(function() {
    $(".datepicker-no-time").datetimepicker({
      pickTime: false
    });
    return $(".datepicker-no-time").on("blur", function(e) {
      return $(this).datepicker("hide");
    });
  });

}).call(this);

